
SECTION code_fcntl

PUBLIC zx_01_output_char_32_tty_15_background_attr

zx_01_output_char_32_tty_15_background_attr:

   ; change background colour
   
   ; de = parameters *
   
   ld a,(de)
   ld (ix+25),a
   
   ret