
dnl############################################################
dnl##      ZX_CRT_1.M4 - GENERATOR FOR ZX_CRT_1.ASM          ##
dnl############################################################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    zx spectrum crt_1                      ;;
;;      generated by target/zx/startup/zx_crt_1.m4           ;;
;;                                                           ;;
;;      48k memory model  (flat 64k address space)           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT AND CLIB CONFIGURATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../crt_defaults.inc"
include "crt_target_defaults.inc"
include "../crt_rules.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SET UP MEMORY MODEL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../crt_memory_model.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GLOBAL SYMBOLS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION CODE

include "../clib_constants.inc"
include "clib_target_constants.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INSTANTIATE DRIVERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
dnl############################################################
dnl## LIST OF AVAILABLE DRIVERS WITH STATIC INSTANTIATORS #####
dnl############################################################
dnl
dnl## input terminals
dnl
dnl#include(../driver/terminal/zx_01_input_kbd_inkey.m4)dnl
dnl#include(../driver/terminal/zx_01_input_kbd_lastk.m4)dnl
dnl
dnl## output terminals
dnl
dnl#include(../driver/terminal/zx_01_output_char_32.m4)dnl
dnl#include(../driver/terminal/zx_01_output_char_32_tty_z88dk.m4)dnl
dnl#include(../driver/terminal/zx_01_output_char_64.m4)dnl
dnl#include(../driver/terminal/zx_01_output_char_64_tty_z88dk.m4)dnl
dnl#include(../driver/terminal/zx_01_output_fzx.m4)dnl
dnl#include(../driver/terminal/zx_01_output_fzx_tty_z88dk.m4)dnl
dnl
dnl## file dup
dnl
dnl#include(../../m4_file_dup.m4)dnl
dnl
dnl############################################################
dnl## INSTANTIATE DRIVERS #####################################
dnl############################################################

include(../../clib_instantiate_begin.m4)

include(../driver/terminal/zx_01_input_kbd_inkey.m4)dnl
m4_zx_01_input_kbd_inkey(_stdin, __i_fcntl_fdstruct_1, 0x02b0, 64, 0, 500, 15)dnl

include(../driver/terminal/zx_01_output_char_32.m4)dnl
m4_zx_01_output_char_32(_stdout, 0x0370, 0, 0, 0, 32, 0, 24, 24, 15360, 56, 0, 56)dnl

include(../../m4_file_dup.m4)dnl
m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl

include(../../clib_instantiate_end.m4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STARTUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION code_crt_start

PUBLIC __Exit

__start:

   IF __crt_enable_restart = 0
   
      ; save state required for successful return to basic
      
      push iy
      exx
      push hl
   
   ENDIF

   ; save stack address for safe exit
   
   ld (__sp),sp

   ; change stack address
   
   IF __register_sp != 0
      
      IF __register_sp = -1
      
         ld sp,0
      
      ELSE
      
         ld sp,__register_sp
      
      ENDIF
   
   ENDIF
   
   ; parse command line
   
   IF 1                        ; __crt_enable_commandline = 1
      
      IF __SDCC | __SDCC_IX | __SDCC_IY
      
         ld hl,0
         push hl               ; environment
         push hl               ; char *argv[]
         push hl               ; int argc

      ELSE
            
         ld hl,0
         push hl               ; int argc
         push hl               ; char *argv[]
         push hl               ; environment
   
      ENDIF
   
   ENDIF
   
   ; initialize bss section
   
   EXTERN ASMHEAD_BSS, ASMSIZE_BSS

   ld hl,ASMHEAD_BSS
   ld bc,ASMSIZE_BSS
   
   ld e,0
   
   EXTERN asm_memset
   call asm_memset
   
   ; initialize data section
   
   IF __crt_model = 1
   
      ; rom model + data segment is not compressed

      EXTERN ASMTAIL_CODE, ASMHEAD_DATA, ASMSIZE_DATA

      ld hl,ASMTAIL_CODE
      ld de,ASMHEAD_DATA
      ld bc,ASMSIZE_DATA
      
      EXTERN asm_memcpy
      call asm_memcpy
   
   ENDIF
   
   IF __crt_model = 2
   
      ; rom model + data segment is compressed
      
      EXTERN ASMTAIL_CODE, ASMHEAD_DATA
      
      ld hl,ASMTAIL_CODE
      ld de,ASMHEAD_DATA
      
      EXTERN asm_dzx7_standard
      call asm_dzx7_standard
   
   ENDIF

SECTION code_crt_init          ; user and library initialization
SECTION code_crt_main

   ; call user program
   
   call _main                  ; hl = return status

   ; run exit stack

   IF __clib_exit_stack_size > 0
   
      EXTERN asm_exit
      jp asm_exit              ; exit function jumps to __Exit
   
   ENDIF

__Exit:

   IF __crt_enable_restart = 0
   
      ; returning to caller

      push hl                  ; save return status
   
   ENDIF
   
SECTION code_crt_exit          ; user and library cleanup
SECTION code_crt_return

   ; close files
   
   IF __crt_enable_close
   
      include "../clib_close.inc"

   ENDIF

   ; exit program
   
   IF __crt_enable_restart = 0
   
      ; returning to caller
      
      pop bc                   ; bc = return status
      
      ld sp,(__sp)             ; reset stack location
      
      pop hl
      exx
      pop iy
      exx
      
      im 1
      ei
      ret
   
   ELSE
   
      ; restarting program
      
      ld sp,(__sp)             ; reset stack location
      jp __start
   
   ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RUNTIME VARS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION bss_user

__sp:  defw 0

include "../clib_variables.inc"
include "clib_target_variables.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CLIB STUBS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../clib_stubs.inc"