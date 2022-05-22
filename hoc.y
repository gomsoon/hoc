%{
#define YYSTYPE double	/* data type of yacc stack */
#include <stdio.h>
%}
%token	NUMBER
%left	'+' '-'		/* left associative, same precedence */
%left	'*' '/'		/* left assoc., higher precedence */
%%
list:		/* nothing */
		| list '\n'
		| list expr '\n'	{ printf("\t%.8g\n", $2); }
		;

expr:		NUMBER			{ $$ = $1; }
		| expr '+' expr		{ $$ = $1 + $3; }
		| expr '-' expr		{ $$ = $1 - $3; }
		| expr '*' expr		{ $$ = $1 * $3; }
		| expr '/' expr		{ $$ = $1 / $3; }
		| '(' expr ')'		{ $$ = $2; }
		;
%%
#include <stdio.h>
#include <ctype.h>

extern int yylex();
extern int yyerror(char* s);
extern void warning(char* s, char* t);

char*	progname;		/* for error messages */
int		lineno = 1;

void main(int argc, char* argv[])	/* hoc1 */
{
	progname = argv[0];
	yyparse();
}

int yylex()		/* hoc1 */
{
	int c;

	while ((c = getchar()) == ' ' || c == '\t')
		;

	if (c == EOF)
		return 0;

	if (c == '.' || isdigit(c)) {	/* number */
		ungetc(c, stdin);
		scanf("%lf", &yylval);
		return NUMBER;
	}

	if (c == '\n')
		lineno++;

	return c;
}

int yyerror(char* s)	/* called for yacc syntax error */
{
	warning(s, NULL);
}

void warning(char* s, char* t)		/* print warning message */
{
	fprintf(stderr, "%s: %s", progname, s);
	if (t)
		fprintf(stderr, " %s", t);
	fprintf(stderr, " near line %d\n", lineno);
}
