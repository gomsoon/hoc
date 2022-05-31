#include "hoc.h"
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>

extern void execerror(char* s, char* t);

static Symbol* sym_malloc(int n);

static Symbol* symlist = (Symbol*)NULL;		/* symbol table: linked list */

Symbol* sym_lookup(char* s)		/* find s in symbol table */
{
	Symbol* sp = (Symbol*)NULL;

	for (sp = symlist; sp != (Symbol*)NULL; sp = sp->next)
	   	if (strncmp(sp->name, s, MAX_SYMBOL_LEN) == 0)
		   return sp;

	return (Symbol*)NULL;		/* NULL ==> not found */
}

Symbol* sym_install(char* s, int t, double d)	/* install s in symbol table */
{
	Symbol* sp = (Symbol*)NULL;

	sp = sym_malloc(sizeof(Symbol));
	sp->name = strdup(s);
	sp->type = t;
	sp->u.val = d;
	sp->next = symlist;		/* put at front of list */
	symlist = sp;
	return sp;
}

Symbol* sym_malloc(int n)	/* check return from malloc */
{
	Symbol* p = (Symbol*)NULL;

	p = (Symbol*)malloc(n);
	if (p == (Symbol*)NULL)
	   execerror("out of memory", NULL);

	return p;
}
