#include "hoc.h"
#include "y.tab.h"
#include <stdio.h>
#include <math.h>

extern double	Log(), Log10(), Exp(), Sqrt(), integer();

static struct {			/* Constants */
   char*	name;
   double	cval;
} consts[] = {
   "PI",	3.14159265358979323846,
   "E",		2.71828182845904523536,
   "GAMMA",	0.57721566490153286060,		/* Euler */
   "DEG",	57.29577951308232087680,	/* deg/radian */
   "PHI",	1.61803398874989484820,		/* golden ratio */
   (char*)NULL,	0.0
};

static struct {			/* Built-ins */
   char*	name;
   double	(*func)();
} builtins[] = {
   "sin",	sin,
   "cos",	cos,
   "atan",	atan,
   "log",	Log,		/* checks argument */
   "log10",	Log10,		/* checks argument */
   "exp",	Exp,		/* checks argument */
   "sqrt",	Sqrt,		/* checks argument */
   "int",	integer,
   "abs",	fabs,
   (char*)NULL,	NULL
};


void sym_init(void)		/* install constants and built-ins in table */
{
	int i = 0;
	Symbol* s = (Symbol*)NULL;

	for (i = 0; consts[i].name; i++)
		sym_install(consts[i].name, VAR, consts[i].cval);

	for (i = 0; builtins[i].name; i++) {
		s = sym_install(builtins[i].name, BLTIN, 0.0);
		s->u.ptr = builtins[i].func;
	}
}


