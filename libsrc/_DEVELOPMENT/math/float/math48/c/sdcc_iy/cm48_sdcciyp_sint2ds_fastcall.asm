
; float __sint2fs_fastcall(signed int si)

SECTION code_fp_math48

PUBLIC cm48_sdcciyp_sint2ds_fastcall

EXTERN am48_double16, cm48_sdcciyp_m482d

cm48_sdcciyp_sint2ds_fastcall:

   ; signed int to double
   ;
   ; enter : stack = signed int si, ret
   ;
   ; exit  : dehl = sdcc_float(si)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   pop af
   pop hl
   push af

   call am48_double16
   
   jp cm48_sdcciyp_m482d