// disable flex / yacc logging https://stackoverflow.com/questions/67764882/bison-yacc-still-printing-debug-messages-despite-tracing-being-explicitly-disabl

%token ID
%token ENTIER

%token KW_PROGRAM
%token KW_BEGIN
%token KW_END
%token KW_VAR
%token KW_INTEGER
%token KW_REAL
%token KW_BOOLEAN

%token SP_COLON
%token SP_DOT
%token SP_COMMA
%token SP_SEMICOLON

%token SP_OPPENING_PARENTHISIS
%token SP_CLOSING_PARENTHISIS

%left OP_PLUS
%left OP_MINUS
%token OP_MULT
%token OP_DIV

%token OP_ASSIGN

%{
  #include <stdio.h>

	#include "utils.h"

  int yylex();
  int yywrap();

  void yyerror(const char *s);

  extern int yy_flex_debug;
%}

%%
PROGRAM     : KW_PROGRAM ID DECLARATION KW_BEGIN INSTRUCTION KW_END SP_DOT           { printf("\n\n"); printf(TEXT_COLOR_GREEN TEXT_WEIGHT_BOLD_SET TEXT_UNDERLINE_SET "[analyseur-syntaxique]:" TEXT_UNDERLINE_RESET TEXT_WEIGHT_BOLD_RESET TEXT_COLOR_RESET " reconnu program"); printf("\n\n"); }

DECLARATION : KW_VAR ID SP_COLON TYPE SP_SEMICOLON DECLARATION
            |
            ;

TYPE        : KW_INTEGER
            | KW_REAL
            | KW_BOOLEAN
            ;

INSTRUCTION : ID OP_ASSIGN EXPRESSION SP_SEMICOLON INSTRUCTION
            |
            ;

EXPRESSION  : EXPRESSION OP_PLUS TERM
            | EXPRESSION OP_MINUS TERM
            | TERM
            ;

TERM        : TERM OP_MULT FACTOR
            | TERM OP_DIV FACTOR
            | FACTOR
            ;

FACTOR      : SP_OPPENING_PARENTHISIS EXPRESSION SP_CLOSING_PARENTHISIS
            | OP_MINUS FACTOR
            | ID
            | ENTIER
            ;
%%

void yyerror (const char *s) /* Called by yyparse on error */
{
  printf("\n\n");
  printf(TEXT_WEIGHT_BOLD_SET TEXT_UNDERLINE_SET TEXT_COLOR_RED "[analyseur-syntaxique](erreur):" TEXT_COLOR_RESET TEXT_UNDERLINE_RESET TEXT_WEIGHT_BOLD_RESET " %s", s);
  printf("\n\n");
}

int main(void)
{
  yy_flex_debug = 0;

  yyparse();

  return 0;
}