

#ifndef __SYS_COMPILER_H__
#define __SYS_COMPILER_H__


/* Temporary fix to turn off features not supported by sdcc */
#ifdef Z88DK_USES_SDCC
#define __LIB__
#define __SAVEFRAME__
#define far
#endif

#define __CHAR_LF '\n'
#define __CHAR_CR '\r'


#endif
