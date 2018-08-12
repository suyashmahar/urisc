#!/usr/bin/env python2.7

from collections import namedtuple
from subprocess import PIPE, Popen

import re
import os
import string
import struct
import subprocess
import sys


""" 
File: verifyBinCreation.py

This script tests the following:
* Differences in the text and the binary file produced by the assembler

"""

def cmdline(command):
    process = Popen(
        args=command,
        stdout=PIPE,
        shell=True
    )
    return process.communicate()[0]

def main():
    ASSEMBLER_LOC = "../../toolchain/python-based/assembler.py"
    ASSEMBLER_NO_ADD_PRINT = "-p-no-add"
    ASSEMBLER_INPUT_FILES = ["sample.asm", "mips.asm"]

    assembler_arg = [ASSEMBLER_NO_ADD_PRINT] + ASSEMBLER_INPUT_FILES
#    print "Starting test: " + ASSEMBLER_LOC + " " + assembler_arg
    assemblerResult = subprocess.check_output([ASSEMBLER_LOC] + assembler_arg)
                                              

    # Generate binary output using the assembler
    ASSEMBLER_GEN_BIN = "-o"
    ASSEMBLER_OP_F_NAME = "a.out"

    subprocess.check_output([ASSEMBLER_LOC] + ASSEMBLER_INPUT_FILES + [ASSEMBLER_GEN_BIN, ASSEMBLER_OP_F_NAME])
    assemblerBinResult = cmdline("xxd -b -c1 a.out | cut -d\" \" -f2 | tr -d \"\n\"")

    if not assemblerBinResult == assemblerResult.replace("\n", ""):
        print "[Failed] Test: " + sys.argv[0]
        print "ASCII: " + assemblerResult
        print "BIN:   " + assemblerBinResult
        sys.exit(1)
    else:
        print "[Passed] Test: " + sys.argv[0]
        sys.exit(0)
    
main()        
