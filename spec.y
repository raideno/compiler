%{

#include <stdio.h>

int yylex();
int yywrap();

void yyerror(const char *s);

%}

%%
S : T '\n'          {printf("Analyse réussie\n"); return 0;}
T : 'a' T 'b'       {printf("found T\n");}
  | 'a' 'b'         {printf("found ab\n");}
  ;
%%

void yyerror (const char *s) /* Called by yyparse on error */
{
  printf("%s\n", s);
}

int main(void)
{
  yyparse();
}