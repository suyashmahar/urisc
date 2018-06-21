#!/usr/bin/env python2.7

from collections import namedtuple
import re
import os
import string
import sys

""" 
Assembler comment format:
@<file-name>::<line-#>::<address>  

"""

# All the regex used
LONG_OPTION_REG = r"-{1,2}[\w-]+"
LABEL_REG = r"\.[\w_-]+"
address = 0

symTable = {}
macroTable = {}


def error(msg, fileName, lineNum):
    print "[%7s] %s:%s: %s" % ("Error", fileName, lineNum, msg)
    sys.exit()


def calc_macro_instr_count(line, symTable, macroTable):
    if line.split()[0] == "subleq":
        return 1
    else:
        acc = 0
        for line in macroTable[line.split()[0]].split("\n"):
            if line.find(':') == -1 and "".join(line.split()) != "":
                acc += calc_macro_instr_count(line, symTable, macroTable)
        return acc


def first_pass(globalBuffer, file, files_to_assemble_map):
    global address
    with open(file) as f:
        lineNum = 1
        macroLineCount = 0
        lastMacroName = ""
        for line in f:
            addrIncr = 0
            # Remove all the extra white space
            splitLine = line.split()
            if (line[0] == ';'):
                continue
            # Check for macros
            elif line.strip() == "":
                lineNum += 1
            elif (splitLine[0] == ".macro"):
                macroLineCount = 1
                lastMacroName = splitLine[1]  # Store macro name to add
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
                    macroTable[lastMacroName] = macroTable[lastMacroName] \
                                                + "\n" + line
                    macroLineCount = 0
            # Check for include statement
            elif (splitLine[0] == ".include"):
                if (files_to_assemble_map[splitLine[1][1:-1]] != ""):
                    globalBuffer = first_pass(globalBuffer,
                                              files_to_assemble_map[splitLine[1][1:-1]],
                                              files_to_assemble)
                else:
                    error("Unable to find file: %s" % splitLine[1],
                          file, lineNum)
                    # Check for label declaration
            elif (splitLine[0] == ".LONG"):
                globalBuffer.append("@%s::%s" % (file, lineNum))
                globalBuffer.append(".LONG " + splitLine[1])
                addrIncr += 1
                lineNum += 1
            elif re.search(LABEL_REG, " ".join(splitLine), re.M | re.I) is not None:
                symTable[re.findall(r"[\w_-]+", splitLine[0],
                                    re.M | re.I)[0]] = address
            # Check for address change
            elif len(splitLine) is 3 and splitLine[0] is "." and splitLine[1] is "=":
                address = int(splitLine[2])
                globalBuffer.append("@%s::%s::%s" % (file, lineNum,
                                                     splitLine[2]))
            else:
                globalBuffer.append("@%s::%s" % (file, lineNum))
                globalBuffer.append(" ".join(line.split()))
                lineNum = lineNum + 1
                if line.split()[0] == "subleq":
                    addrIncr = 1
                else:
                    addrIncr = calc_macro_instr_count(line, symTable, macroTable)
            address += addrIncr
    return globalBuffer

def get_value(arg, symTable):
    try:
        return int(arg)
    except ValueError:
        return int(symTable[arg])

def assemble_instruction(instr, symTable):
    global address
    splitInstr = re.findall(r"[\w0-9]+", instr)
    result = []
    if splitInstr[0] == 'subleq':

        if len(splitInstr) == 4:  # Subleq with 3 parameters
            result.append("%5s" % str(address) + ":0000{0:020b}{1:020b}{2:020b}".format(get_value(splitInstr[3], symTable),
                                                          get_value(splitInstr[2], symTable),
                                                          get_value(splitInstr[1], symTable)))
        else:  # Subleq with 2 parameters
            result.append("%5s" % str(address) + ":0000{0:020b}{1:020b}{2:020b}".format(get_value((address+1), symTable),
                                                          get_value(splitInstr[2], symTable),
                                                          get_value(splitInstr[1], symTable)))
        address += 1 # Increment address for the next instruction to be assembled
    # Storing a LONG
    elif splitInstr[0] == "LONG":
        result.append("%5s" % str(address) + ":{0:064b}".format(int(splitInstr[1])))
        address += 1
    elif macroTable[splitInstr[0]] != "":
        args = {}
        count = 0
        for line in macroTable[splitInstr[0]].splitlines():
            if line.find(":") != -1:
                for arg in re.findall(r"[\w]+", instr)[1:]:
                    args['_' + str(count) + '_'] = str(arg)
                    count += 1
            else:
                result.append(assemble_instruction(line.format(**args), symTable))
    elif splitInstr[0] == ".":
        result = []
    else:
        error("Unknown instruction '%s' :-(" % splitInstr[0], "", 0)
    return result


def pre_process(files_to_assemble, files_to_assemble_map):
    # Start with the first file
    return first_pass([], files_to_assemble[0], files_to_assemble_map)


def second_pass(globalBuffer, symTable):
    global address
    assembledCode = []
    address = 0
    for curLine in globalBuffer:
        if curLine[0] is "@":
            splitLine = curLine.split("::")
            if len(splitLine) > 2:
                address = int(splitLine[2])
        else:
            assembledCode.append(assemble_instruction(curLine,
                                                      symTable))
###            address = address + 1
    return assembledCode


files_to_assemble = list(filter(lambda x: None ==
                                          re.search(LONG_OPTION_REG,
                                                    x, re.M | re.I),
                                sys.argv[1:]))
files_to_assemble_map = {}
for file in files_to_assemble:
    files_to_assemble_map[os.path.split(file)[1]] = file

globalBuffer = pre_process(files_to_assemble, files_to_assemble_map)
assembledOutput = second_pass(globalBuffer, symTable)

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


def printAssembledOuput(assembledOutput):
    for element in assembledOutput:
        if isinstance(element, basestring):
            print element
        else:
            printAssembledOuput(element)


if '-p' in sys.argv[1:]:
    printAssembledOuput(assembledOutput)
