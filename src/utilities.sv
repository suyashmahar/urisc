import gc::*;

`include "cFunctions.svh"

package utils;
   function _assert;
      input assertVal;
      input string assertionStr;
      input int    lineNum;
      input string fileName;
       if (!assertVal) begin
	   $error(assertionStr);
       end
   endfunction // _assert

   function arg_size;
       input gc::ARGS arg;
       case (arg) 
	 gc::A,gc::B,gc::C: begin
	     return 20;
	 end
	 default: begin
	     _assert_(0,"Passed argument does not exist.");
	 end	   
       endcase // case (arg)
   endfunction // arg_size

   function arg_up_bound;
      input gc::ARGS arg;
       case (arg) 
	 gc::A: begin
	     return arg_size(gc::A) 
                  - 1;
	 end
	 gc::B: begin
	     return arg_size(gc::A) 
	          + arg_size(gc::B) 
	          - 1;
	 end
	 gc::C: begin
	     return arg_size(gc::A) 
	          + arg_size(gc::B) 
	          + arg_size(gc::C) 
	          - 1;
	 end
       endcase // case (arg)
   endfunction // get_arg_upper_bound
   
   function arg_low_bound;
      input gc::ARGS arg;
       case (arg) 
	 gc::A: begin
	     return 0;
	 end
	 gc::B: begin
	     return arg_size(gc::A);
	 end
	 gc::C: begin
	     return arg_size(gc::A) 
	          + arg_size(gc::B);
	 end
       endcase // case (arg)
   endfunction // get_arg_upper_bound
endpackage // utilities
   
