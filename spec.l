%{
	#include <stdio.h>
	#include <string.h>
	#include <stdbool.h>

	#include "utils.h"
	#include "analyseur-syntaxique.h"

	#define MAX_LINES 1024
	#define MAX_COLUMN_LENGTH 32

	int ligne = 0;
	int ligne_char = 0;

	// Creation et Remplissage Table separateurs
	int separateurs_table_length = 6;
	char separateurs_table[MAX_LINES][MAX_COLUMN_LENGTH] = {
		",",
		".",
		":",
		";",
		"(",
		")"
	};
	int corresponding_separateurs_table[] = {
		SP_COMMA,
		SP_DOT,
		SP_COLON,
		SP_SEMICOLON,
		SP_OPPENING_PARENTHISIS,
		SP_CLOSING_PARENTHISIS
	};

	// Creation et Remplissage Table des operateurs
	int operateurs_table_length = 5;
	char operateurs_table[MAX_LINES][MAX_COLUMN_LENGTH] = {
		"+",
		":=",
		"-",
		"*",
		"/"
	};
	int corresponding_operateurs_table[] = {
		OP_PLUS,
		OP_ASSIGN,
		OP_MINUS,
		OP_MULT,
		OP_DIV
	};

	// Creation et Remplissage Table des mots clés
	int keywords_table_length = 7;
	char keywords_table[MAX_LINES][MAX_COLUMN_LENGTH] = {
		"program",
		"begin",
		"end",
		"var",
		"integer",
		"real",
		"boolean",
	};
	int corresponding_keywords_table[] = {
		KW_PROGRAM,
		KW_BEGIN,
		KW_END,
		KW_VAR,
		KW_INTEGER,
		KW_REAL,
		KW_BOOLEAN
	};

	// Creation et Table des symboles
	int symboles_table_length = 0;
	char symboles_table[MAX_LINES][MAX_COLUMN_LENGTH];

	// Afficher des lignes sur le terminal
	void print_lines(int lines_number)
	{
		while(lines_number > 0)
		{
			printf("\n");
			lines_number--;
		}
	}

	// Fonction qui recois une table et l'affiche dans le terminal
	void print_table(char table[][MAX_COLUMN_LENGTH], int rows_length, char *column_1_name, char *column_2_name)
	{
		printf("+--------------------------------+--------------------------------+");
		printf("\n");
		printf("|" TEXT_UNDERLINE_SET TEXT_WEIGHT_BOLD_SET "%-32s" TEXT_WEIGHT_BOLD_RESET TEXT_UNDERLINE_RESET "|" TEXT_UNDERLINE_SET TEXT_WEIGHT_BOLD_SET "%-32s" TEXT_WEIGHT_BOLD_RESET TEXT_UNDERLINE_RESET "|", column_1_name, column_2_name);
		printf("\n");
		printf("+--------------------------------+--------------------------------+");
		printf("\n");
		for (int i = 0; i < rows_length; i++)
		{
			printf("|%-32d|%-32s|", i, table[i]);
			printf("\n");
			printf("+--------------------------------+--------------------------------+");
			printf("\n");
		}
	}

	// Recois une table et un string, si le string est present dans la table retorune son indice sinon -1
	int find_from_table(char table[][MAX_COLUMN_LENGTH], int rows_length, char* string)
	{
		for (int i = 0; i < rows_length; i++)
			if (strcmp(string, table[i]) == 0)
				return i;
		return -1;
	}

	// Inserer un string dans une table a un certain indice (dernier)
	int insert_on_table(char table[][MAX_COLUMN_LENGTH], int rows_length, char* string)
	{
		int insertion_index = rows_length;
		strcpy(table[insertion_index], string);
		rows_length++;
		return insertion_index;
	}

	// Recois un string et retourne son indice dans la table si il est present sinon l'insert et retourne son indice
	int get_symbole_id_or_insert(char *symbole)
	{
		int symbole_id = -1;

		symbole_id = find_from_table(symboles_table, symboles_table_length, symbole);

		if (symbole_id == -1)
		{
			int insertion_index = insert_on_table(symboles_table, symboles_table_length, symbole);
			symboles_table_length++;
			return insertion_index;
		}
		else
			return symbole_id;
	}
%}

LETTRE [a-z]|[A-Z]
CHIFFRE [0-9]
UNDERSCORE _

SEPARATEUR ;|:|\.|,|\)|\(

OPERATEUR \+|:=|\*|-|\/

KEYWORD program|begin|end|var|integer|real|boolean

ID ({UNDERSCORE}|{LETTRE})({UNDERSCORE}|{CHIFFRE}|{LETTRE})*

CONSTANTE ({CHIFFRE})+

%%

{KEYWORD}  	    										{int kw_id = find_from_table(keywords_table, keywords_table_length, yytext); printf("<keyword, %d>", kw_id); return corresponding_keywords_table[kw_id]; }

{ID}       												{int sym_id = get_symbole_id_or_insert(yytext); printf("<symbole, %d>", sym_id); return ID;}

{CONSTANTE}       										{printf("<constante, %s>", yytext); yylval = atoi(yytext); return ENTIER;}

{SEPARATEUR}											{int sp_id = find_from_table(separateurs_table, separateurs_table_length, yytext); printf("<separateur, %d>", sp_id); return corresponding_separateurs_table[sp_id]; }

{OPERATEUR}												{int op_id = find_from_table(operateurs_table, operateurs_table_length, yytext); printf("<operateur, %d>", op_id); return corresponding_operateurs_table[op_id]; }


[\t\r ]									    			{;/*printf("<space, %s>", yytext);*/}

[\n]													{ligne++; ligne_char = 0;/*printf("<line-break, %s>", yytext);*/}

[^a-z]|[^A-Z]|[^0-9]|[^;,:\.\(\)]|[^+\-\*\/]|[^\t\n\r ]|^:|=		{printf("\n\n"); printf(TEXT_WEIGHT_BOLD_SET TEXT_UNDERLINE_SET TEXT_COLOR_RED "[analyseur-lexicale](erreur):" TEXT_COLOR_RESET TEXT_UNDERLINE_RESET TEXT_WEIGHT_BOLD_RESET " ligne-%d:%d, " TEXT_UNDERLINE_SET TEXT_WEIGHT_BOLD_SET "%s" TEXT_WEIGHT_BOLD_RESET TEXT_UNDERLINE_RESET, ligne + 1, ligne_char, yytext); printf("\n\n"); exit(EXIT_FAILURE);}

%%

int yywrap() {
    return 1;
}