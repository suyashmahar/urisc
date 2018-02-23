package utilities;
   function _assert;
      input assertVal;
       if (!assertVal) begin
	   $error("Assertion failed");
       end
   endfunction // _assert
endpackage // utilities
   
