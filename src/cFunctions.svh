`ifndef __URISC_C_FUNCTIONS_SV_HEADER__
 `define __URISC_C_FUNCTIONS_SV_HEADER__

 // Macro to define c like assertion function
 `define _assert_(val, str) \
  if (!``val``) begin \
      $error("%s", ``str``); \
  end
`endif
