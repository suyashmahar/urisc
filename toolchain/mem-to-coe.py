import sys

if (len(sys.argv) < 2):
    print "Usage: ./convert input-mem-file mem-size"
    exit
else:
    input_file = sys.argv[1]
    mem_size = int(sys.argv[2])
    print "memory_initialization_radix=2;\nmemory_initialization_vector="
    in_f = open(input_file)

    count = 0
    for line in in_f:
	if (count == mem_size-1):
            print line.strip()  + ";"
        else:
            print line.strip()  + ","
        count += 1

    if (count < mem_size):
        for i in range(mem_size - count):
            if (i == mem_size-count-1):
                print "0000000000000000000000000000000000000000000000000000000000000000;"
            else:
                print "0000000000000000000000000000000000000000000000000000000000000000,"
    elif (count > mem_size):
        print "input file size error"
        
