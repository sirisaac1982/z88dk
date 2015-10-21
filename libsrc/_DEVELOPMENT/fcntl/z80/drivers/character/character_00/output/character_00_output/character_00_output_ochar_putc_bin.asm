
INCLUDE "clib_cfg.asm"

SECTION code_fcntl

PUBLIC character_00_output_ochar_msg_putc_bin

EXTERN OCHAR_MSG_PUTC

character_00_output_ochar_msg_putc_bin:

   ; derived driver is in text mode
   ;
   ; enter   : c = char
   ;
   ; can use : af, bc, de, hl, af'
   
   bit 4,(ix+6)
   jr z, putchar               ; if not processing crlf
   
   ld a,c
   
   cp CHAR_CR
   ret z                       ; ignore cr
   
   cp CHAR_LF
   jr nz, putchar
   
   ; send cr+lf
   
   ld c,13
   call putchar
   
   ld c,10

putchar:

   ; c = char
   
   ld a,OCHAR_MSG_PUTC
   jp (ix)