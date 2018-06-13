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
LABEL_REG=r"\.[\w_-]+"

symTable = {}
macroTable = {}
def error(msg, fileName, lineNum):
    print "[%7s] %s:%s: %s" %("Error", fileName, lineNum, msg)
    #sys.exit()
    
def first_pass(globalBuffer, file, address, files_to_assemble):
    with open(file) as f:
        lineNum = 1
        macroLineCount = 0
        lastMacroName = ""
        for line in f:
            addrIncr = 0
            # Remove all the extra white space
            splitLine = line.split()
            # Check for macros
            print splitLine
            
            if (splitLine[0] == ".macro"):
                macroLineCount = 1
                lastMacroName = splitLine[1] # Store macro name to add
                                             # content later
                macroTable[lastMacroName] = lastMacroName + ":" + splitLine[2]
                if (splitLine[3] == "\\"):
                    macroLineCount += 1
                else:
                    error("Macro error :-(", lineNum, file)
            elif (macroLineCount > 0):
                if ord(line[-2:-1]) == 92:
                    macroTable[lastMacroName] = macroTable[lastMacroName] \
                                              + "\n" + line[:-2]
                    macroLineCount += 1
                else:
                    print "dfadf"
                    print ord(line[-2:-1])
                    macroTable[lastMacroName] = macroTable[lastMacroName] \
                                              + "\n" + line
                    macroLineCount = 0
            # Check for include statement
            elif (splitLine[0] == ".include"):
                if (splitLine[1][1:-1] in files_to_assemble):
                    globalBuffer = first_pass(globalBuffer,
                                              splitLine[1][1:-1],
                                              address+1,
                                              files_to_assemble)
                else:
                    error("Unable to find file: %s" % splitLine[1],
                          file, lineNum)
                    # Check for label declaration
            elif re.search(LABEL_REG, " ".join(splitLine), re.M|re.I) is not None:
                symTable[re.findall(r"[\w_-]+", splitLine[0],
                                    re.M|re.I)[0]] = address;
                # Check for address change
            elif len(splitLine) is 3 and splitLine[0] is "." and splitLine[1] is "=":
                print int(address)
                address = int(splitLine[2])
            else:
                addrIncr = 1
                globalBuffer.append("@%s::%s::%s" % (file, lineNum,
                                                     address))
                globalBuffer.append(" ".join(line.split()))
                lineNum = lineNum+1
                address = address+addrIncr
    return globalBuffer

def assemble_instruction(instr, symTable):
    splitInstr = re.findall(r"[\w]+", instr)

    if splitInstr[0] == 'subleq':
        return "0{0:05b}{0:05b}{0:05b}".format(int(splitInstr[1]), int(splitInstr[2]), int(splitInstr[3]))
    elif splitInstr[0] == ".":
        return ""
    else:
        error("Unkown instruction '%s' :-(" % splitInstr[0], "", 0)
        
def preprocess(files_to_assemble):
    # Start with the first file
    return first_pass([], files_to_assemble[0], 0, files_to_assemble)

def second_pass(globalBuffer, symTable):
    assembledCode = []
    file = "Error"
    line = 0
    address = 0
    for line in globalBuffer:
        if line[0] is "@":
            splitLine = line.split("::")
            file = splitLine[0]
            line = splitLine[1]
            address = splitLine[2]
            #print "File: %s Line: %s Address: %s" % (file, line, address)
        else:
            assembledCode.append(assemble_instruction(line, symTable))
    return assembledCode

files_to_assemble = list(filter(lambda x : None ==
                                 re.search(LONG_OPTION_REG, x,
                                           re.M|re.I), sys.argv[1:]))

globalBuffer = preprocess(files_to_assemble)
print second_pass(globalBuffer, symTable)

if '-E' in sys.argv[1:]:
    for line in globalBuffer:
        print line

if '-g' in sys.argv[1:]:
    print "Symbol table:"
    for sym in symTable:
        print sym + ": " + str(symTable[sym])

if '-m' in sys.argv[1:]:
    print macroTable
    print "Macro table:"
    for macro in macroTable:
        print "%s: %s" % (macro, macroTable[macro])
