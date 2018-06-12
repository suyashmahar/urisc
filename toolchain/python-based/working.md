## Pass 1
1. Go line by line preprocessing the file:
   1. Recursively preprocess all include statement
   2. Add comments to each line in the following format:
	   <file-name>::<line-num>::<address>
   2. go through all the line constructing a symbol table
## Pass 3
1. Go through each line and assemble the code with global buffer and
   sym table
	
	
	
	
	
