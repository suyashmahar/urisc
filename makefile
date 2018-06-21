program_NAME := usim
program_C_SRCS := $(wildcard simulator/*.c)
program_CXX_SRCS := $(wildcard simulator/*.cpp)
program_C_OBJS := ${program_C_SRCS:.cpp=.o}
program_CXX_OBJS := ${program_CXX_SRCS:.cpp=.o}
program_OBJS := $(program_C_OBJS) $(program_CXX_OBJS)
program_INCLUDE_DIRS := ./simulator
program_LIBRARY_DIRS :=

CXXFLAGS += -std=c++11

CXXFLAGS += $(foreach includedir,$(program_INCLUDE_DIRS),-I$(includedir))
LDFLAGS += $(foreach librarydir,$(program_LIBRARY_DIRS),-L$(librarydir))

.PHONY: all clean distclean

all: $(program_NAME)

CC=g++

debug: CXXFLAGS += -DDEBUG -g -Og -fsanitize=address
debug: $(program_NAME)

$(program_NAME): $(program_OBJS)
	$(CC) $(CXXFLAGS) $(program_OBJS) -o bin/$(program_NAME) $(LDFLAGS)

clean:
	@- $(RM) bin/$(program_NAME)

distclean: clean
