; Performs an unconditional jump to the destination specified
.macro jmp 1 \
subleq 0 0 {_0_}

; Writes zero to a location
.macro zero 1 \
subleq {_0_} {_0_}

; Moves data from location in fist argument to the second location
.macro mv 2 \
subleq 3 3 \
subleq {_0_} 3 \
subleq {_1_} {_1_} \
subleq 3 {_1_}

; Negate data of a location
.macro neg 1 \
zero 3 \
subleq {_0_} 3 \
mv 3 {_0_}
