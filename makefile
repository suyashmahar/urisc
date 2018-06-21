program_NAME := usim
program_C_SRCS := $(wildcard simulator/*.c)
program_CXX_SRCS := $(wildcard simulator/*.cpp)
program_C_OBJS := ${program_C_SRCS:.cpp=.o}
program_CXX_OBJS := ${program_CXX_SRCS:.cpp=.o}
program_OBJS := $(program_C_OBJS) $(program_CXX_OBJS)
program_INCLUDE_DIRS := ./simulator
program_LIBRARY_DIRS :=

CFLAGS += -o3
CPPFLAGS += -std=c++11 -O3

CPPFLAGS += $(foreach includedir,$(program_INCLUDE_DIRS),-I$(includedir))
CFLAGS += $(foreach includedir,$(program_INCLUDE_DIRS),-I$(includedir))
LDFLAGS += $(foreach librarydir,$(program_LIBRARY_DIRS),-L$(librarydir))

CC=g++

.PHONY: all clean distclean

all: $(program_NAME)

debug: CPPFLAGS += -DDEBUG -g -og
debug: CFLAGS += -g -og
debug: $(program_NAME)

$(program_NAME): $(program_OBJS)
	$(CC) $(CPPFLAGS) $(program_OBJS) -o bin/$(program_NAME) $(LDFLAGS)

clean:
	@- $(RM) bin/$(program_NAME)
	@- $(RM) $(program_OBJS)

distclean: clean
