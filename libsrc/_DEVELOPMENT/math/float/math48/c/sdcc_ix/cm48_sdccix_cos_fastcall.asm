
; float cos(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdccix_cos_fastcall

EXTERN cm48_sdccixp_dx2m48, am48_cos, cm48_sdccixp_m482d

cm48_sdccix_cos_fastcall:

   call cm48_sdccixp_dx2m48
   
   call am48_cos
   
   jp cm48_sdccixp_m482d