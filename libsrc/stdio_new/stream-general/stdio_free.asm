; stdio_free
; 06.2008 aralbrec

XLIB stdio_free

LIB HeapFree_callee
XREF ASMDISP_HEAPFREE_CALLEE, _stdio_heap

; Stdio file objects are allocated from the stdio heap
; (_stdio_heap) which may or may not be the same heap used
; by the regular malloc call.  This is an opportunity
; for machines with bankswitched memory to locate stdio
; and the dynamic memory it uses in its own bank.

.stdio_free

   ; enter : hl = block to be freed
   ; uses  : af, bc, de, hl
   
   ld de,_stdio_heap
   jp HeapFree_callee + ASMDISP_HEAPFREE_CALLEE
