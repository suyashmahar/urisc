import sys

if (len(sys.argv) < 1):
    print "Usage: ./convert input-mem-file"
    exit
else:
    input_file = sys.argv[1]
    in_f = open(input_file)

    count = 0
    for line in in_f:
	print "mem[" + str(count) + "] = 64'b" + line.strip() + ";"
        count+=1
