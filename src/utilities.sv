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
       return 1;
       
   endfunction // _assert
endpackage // utilities
   
