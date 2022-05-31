%{
#include "hoc.h"
#include <stdio.h>
int yylex(void);
int yyerror(char* s);
void execerror(char* s, char* t);
extern double Pow();
%}
%union {			/* stack type */
	double	val;	/* actual value */
	Symbol*	sym;	/* symbol table pointer */
}
%token	<val>		NUMBER
%token	<sym>		VAR BLTIN UNDEF
%type	<val>		expr asgn
%right	'='
%left	'+' '-'		/* left associative, same precedence */
%left	'*' '/'		/* left assoc., higher precedence */
%left	UNARYMINUS	/* unary minus operator */
%right	'^'			/* exponentiation */
%%
list:		/* nothing */
		| list '\n'
		| list asgn '\n'
		| list expr '\n'	{ printf("\t%.8g\n", $2); }
		| list error '\n'	{ yyerrok; }
		;
asgn:	  VAR '=' expr		{ $$ = $1->u.val = $3; $1->type = VAR; }
		;
expr:	  NUMBER
		| VAR				{ if ($1->type == UNDEF)
									execerror("undefined variable", $1->name);
							  $$ = $1->u.val; }
		| asgn
		| BLTIN '(' expr ')'	{ $$ = (*($1->u.ptr))($3); }
		| expr '+' expr		{ $$ = $1 + $3; }
		| expr '-' expr		{ $$ = $1 - $3; }
		| expr '*' expr		{ $$ = $1 * $3; }
		| expr '/' expr		{ 
				if ($3 == 0.0)
					execerror("division by zero", NULL);
				$$ = $1 / $3; 
			}
		| expr '^' expr		{ $$ = Pow($1, $3); }
		| '(' expr ')'		{ $$ = $2; }
		| '-' expr	%prec UNARYMINUS { $$ = -$2; }
		;
%%
#include <stdio.h>
#include <ctype.h>
#include <signal.h>
#include <setjmp.h>

extern void sym_init(void);

jmp_buf begin;

void fpecatch(int signo);
int yylex(void);

char*	progname;		/* for error messages */
int		lineno = 1;

void main(int argc, char* argv[])	/* hoc2 */
{

	progname = argv[0];

	sym_init();
	setjmp(begin);
	signal(SIGFPE, fpecatch);
	yyparse();
}


int yylex()		/* hoc3 */
{
	int c;

	while ((c = getchar()) == ' ' || c == '\t')
		;

	if (c == EOF)
		return 0;

	if (c == '.' || isdigit(c)) {	/* number */
		ungetc(c, stdin);
		scanf("%lf", &yylval.val);
		return NUMBER;
	}

	if (isalpha(c)) {
		Symbol* s = (Symbol*)NULL;
		char sbuf[100];
		char* p = sbuf;

		do {
			*p++ = c;
		} while ((c = getchar()) != EOF && isalnum(c));
		ungetc(c, stdin);
		*p = '\0';

		s = sym_lookup(sbuf);

		if (s == (Symbol*)NULL)
			s = sym_install(sbuf, UNDEF, 0.0);

		yylval.sym = s;

		return s->type == UNDEF ? VAR : s->type;
	}

	if (c == '\n')
		lineno++;

	return c;
}


void warning(char* s, char* t)		/* print warning message */
{
	fprintf(stderr, "%s: %s", progname, s);
	if (t)
		fprintf(stderr, " %s", t);
	fprintf(stderr, " near line %d\n", lineno);
}

void execerror(char* s, char* t)	/* recover from run-time error */
{
	warning(s, t);
	longjmp(begin, 0);
}

int yyerror(char* s)	/* called for yacc syntax error */
{
	warning(s, NULL);
}

void fpecatch(int signo)						/* catch floating point exceptions */
{
	execerror("floating point exception", NULL);
}
