%{
#define YYSTYPE double	/* data type of yacc stack */
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
