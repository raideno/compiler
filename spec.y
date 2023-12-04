%{

#include <stdio.h>

int yylex();
void yyerror(char *s);

%}

%%

S : T '\n'          {printf("Analyse réussie\n"); return 0;}
T : 'a' T 'b'       {printf("found T\n");}
  | 'a' 'b'         {printf("found ab\n");}
  ;

%%

void yyerror(char *s)
{ 
    printf("%s\n", s);
}

int yylex()
{
    return getchar();
}

int main(void)
{
    yyparse();
}