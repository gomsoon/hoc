#ifndef __HOC_H__
#define __HOC_H__

#define MAX_SYMBOL_LEN	255

typedef struct Symbol {	/* symbol table entry */
	char*	name;
	int		type;		/* VAR, BLTIN, UNDEF */
	union {
		double val;				/* if VAR */
		double (*ptr)();		/* if BLTIN */
	} u;

	struct Symbol*	next;	/* to link to another */
} Symbol;

Symbol*		sym_install();
Symbol*		sym_lookup();

#endif
