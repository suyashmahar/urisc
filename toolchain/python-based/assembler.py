#!/usr/bin/env python2.7

from collections import namedtuple
import re
import string
import sys

""" 
Assembler comment format:
@<file-name>::<line-#>::<address>  

"""

# All the regex used
LONG_OPTION_REG=r"-{1,2}[\w-]+"

sym_table = {}

def error(msg, fileName, lineNum):
    print "[%7s] %s:%s: %s" %("Error", fileName, lineNum, msg)
    #sys.exit()
    
def first_pass(globalBuffer, file, address, files_to_assemble):
    with open(file) as f:
        lineNum = 1
        for line in f:
            # Remove all the extra white space
            splitLine = line.split()
            globalBuffer.append("@%s::%s::%s" % (file, \
                                lineNum, address))
            if (splitLine[0] == ".include"):
                if (splitLine[1][1:-1] in files_to_assemble):
                    globalBuffer = first_pass(globalBuffer,
                                               splitLine[1][1:-1], address,
                                               files_to_assemble)
                else:
                    error("Unable to find file: %s" % splitLine[1],
                          file, lineNum)
            else:
                globalBuffer.append(" ".join(line.split()))
            lineNum = lineNum+1
    return globalBuffer
                    
                
            
            
def preprocess(files_to_assemble):
    # Start with the first file
    return first_pass([], files_to_assemble[0], 0, files_to_assemble)
    
files_to_assemble = list(filter(lambda x : None ==
                                re.search(LONG_OPTION_REG,
                                          x, re.M|re.I),
                                sys.argv[1:]))

globalBuffer = preprocess(files_to_assemble)
if '-E' in sys.argv[1:]:
    for line in globalBuffer:
        print line
    
    
