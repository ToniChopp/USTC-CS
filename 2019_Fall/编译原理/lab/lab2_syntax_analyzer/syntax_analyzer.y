%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common/common.h"
#include "syntax_tree/SyntaxTree.h"

#include "lab1_lexical_analyzer/lexical_analyzer.h"

// external functions from lex
extern int yylex();
extern int yyparse();
extern int yyrestart();
extern FILE * yyin;

// external variables from lexical_analyzer module
extern int lines;
extern char * yytext;

// Global syntax tree.
SyntaxTree * gt;

void yyerror(const char * s);
%}

%union {
/********** TODO: Fill in this union structure *********/
	SyntaxTreeNode * node;
}

/********** TODO: Your token definition here ***********/
%token ERROR
%token ADD SUB MUL DIV LT LTE GT GTE EQ NEQ ASSIN 
%token SEMICOLON COMMA LPARENTHESE RPARENTHESE LBRACKET RBRACKET LBRACE RBRACE
%token ELSE IF INT RETURN VOID WHILE IDENTIFIER NUMBER ARRAY EOL COMMENT BLANK 
/* compulsory starting symbol */
%start program

%%
/*************** TODO: Your rules here *****************/
program :declaration_list 
{
	gt->root = newSyntaxTreeNode("program"); 
	SyntaxTreeNode_AddChild(gt->root, $<node>1);
}
;
declaration_list:declaration_list declaration 
{
	$<node>$ = newSyntaxTreeNode("declaration-list");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
} |
declaration 
{
	$<node>$ = newSyntaxTreeNode("declaration-list"); 
    SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
declaration:var_declaration 
{
	$<node>$ = newSyntaxTreeNode("declaration");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
fun_declaration
{
	$<node>$ = newSyntaxTreeNode("declaration");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
var_declaration:type_specifier IDENTIFIER SEMICOLON 
{
	$<node>$ =newSyntaxTreeNode("var-declaration");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
} | 
type_specifier IDENTIFIER LBRACKET NUMBER RBRACKET SEMICOLON 
{
	$<node>$ = newSyntaxTreeNode("var-declaration");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
	SyntaxTreeNode_AddChild($<node>$, $<node>4);
	SyntaxTreeNode_AddChild($<node>$, $<node>5);
	SyntaxTreeNode_AddChild($<node>$, $<node>6);
}
;
type_specifier:INT
{
	$<node>$ = newSyntaxTreeNode("type-specifier");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
VOID
{
	$<node>$ = newSyntaxTreeNode("type-specifier");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
fun_declaration:type_specifier IDENTIFIER LPARENTHESE params RPARENTHESE compound_stmt 
{
	$<node>$ = newSyntaxTreeNode("fun-declaration"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
	SyntaxTreeNode_AddChild($<node>$, $<node>4);
	SyntaxTreeNode_AddChild($<node>$, $<node>5);
	SyntaxTreeNode_AddChild($<node>$, $<node>6);
}
;
params:param_list
{
	$<node>$ = newSyntaxTreeNode("params");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
VOID
{
	$<node>$ = newSyntaxTreeNode("params");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
param_list:param_list COMMA param
{
	$<node>$ = newSyntaxTreeNode("param-list");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
} |
param
{
	$<node>$ = newSyntaxTreeNode("param-list");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
param:type_specifier IDENTIFIER
{
	$<node>$ = newSyntaxTreeNode("param");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
} |
type_specifier IDENTIFIER ARRAY
{
	$<node>$ = newSyntaxTreeNode("param");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
}
;
compound_stmt:LBRACE local_declarations statement_list RBRACE
{
	$<node>$ = newSyntaxTreeNode("compound-stmt"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
	SyntaxTreeNode_AddChild($<node>$, $<node>4);
}
;
local_declarations:local_declarations var_declaration
{
	$<node>$ = newSyntaxTreeNode("local-declarations"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
} |
epsilon
{
	$<node>$ = newSyntaxTreeNode("local-declarations"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
statement_list:statement_list statement
{
	$<node>$ = newSyntaxTreeNode("statement-list"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
} |
epsilon
{
	$<node>$ = newSyntaxTreeNode("statement-list"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
statement:expression_stmt
{
	$<node>$ = newSyntaxTreeNode("statement"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
compound_stmt
{
	$<node>$ = newSyntaxTreeNode("statement"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
selection_stmt
{
	$<node>$ = newSyntaxTreeNode("statement"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
iteration_stmt
{
	$<node>$ = newSyntaxTreeNode("statement"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
return_stmt
{
	$<node>$ = newSyntaxTreeNode("statement"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
expression_stmt:expression SEMICOLON
{
	$<node>$ = newSyntaxTreeNode("expression-stmt"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
} |
SEMICOLON
{
	$<node>$ = newSyntaxTreeNode("expression-stmt"); 
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
selection_stmt:IF LPARENTHESE expression RPARENTHESE statement %prec LOWER_THAN_ELSE 
{
	$<node>$ =newSyntaxTreeNode("selection-stmt");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
	SyntaxTreeNode_AddChild($<node>$, $<node>4);
	SyntaxTreeNode_AddChild($<node>$, $<node>5);
} | 
IF LPARENTHESE expression RPARENTHESE statement ELSE statement 
{
	$<node>$ =newSyntaxTreeNode("selection-stmt");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
	SyntaxTreeNode_AddChild($<node>$, $<node>4);
	SyntaxTreeNode_AddChild($<node>$, $<node>5);
	SyntaxTreeNode_AddChild($<node>$, $<node>6);
	SyntaxTreeNode_AddChild($<node>$, $<node>7);
}
;
iteration_stmt:WHILE LPARENTHESE expression RPARENTHESE statement
{
	$<node>$ =newSyntaxTreeNode("iteration-stmt");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
	SyntaxTreeNode_AddChild($<node>$, $<node>4);
	SyntaxTreeNode_AddChild($<node>$, $<node>5);
}
;
return_stmt:RETURN SEMICOLON
{
	$<node>$ =newSyntaxTreeNode("return-stmt");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
} |
RETURN expression SEMICOLON
{
	$<node>$ =newSyntaxTreeNode("return-stmt");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
}
;
expression:var ASSIN expression
{
	$<node>$ =newSyntaxTreeNode("expression");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
} |
simple_expression
{
	$<node>$ =newSyntaxTreeNode("expression");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
var:IDENTIFIER
{
	$<node>$ =newSyntaxTreeNode("var");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
IDENTIFIER LBRACKET expression RBRACKET
{
	$<node>$ =newSyntaxTreeNode("var");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
	SyntaxTreeNode_AddChild($<node>$, $<node>4);
}
;
simple_expression:additive_expression relop additive_expression
{
	$<node>$ =newSyntaxTreeNode("simple-expression");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
} |
additive_expression
{
	$<node>$ =newSyntaxTreeNode("simple-expression");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
relop:LTE
{
	$<node>$ =newSyntaxTreeNode("relop");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
LT
{
	$<node>$ =newSyntaxTreeNode("relop");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
GT 
{
	$<node>$ =newSyntaxTreeNode("relop");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
GTE 
{
	$<node>$ =newSyntaxTreeNode("relop");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
EQ
{
	$<node>$ =newSyntaxTreeNode("relop");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
NEQ
{
	$<node>$ =newSyntaxTreeNode("relop");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
additive_expression:additive_expression addop term
{
	$<node>$ =newSyntaxTreeNode("additive-expression");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
} |
term
{
	$<node>$ =newSyntaxTreeNode("additive-expression");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
addop:ADD
{
	$<node>$ =newSyntaxTreeNode("addop");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
SUB
{
	$<node>$ =newSyntaxTreeNode("addop");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
term:term mulop factor
{
	$<node>$ =newSyntaxTreeNode("term");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
} |
factor
{
	$<node>$ =newSyntaxTreeNode("term");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
mulop:MUL
{
	$<node>$ =newSyntaxTreeNode("mulop");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
DIV
{
	$<node>$ =newSyntaxTreeNode("mulop");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
factor:LPARENTHESE expression RPARENTHESE 
{
	$<node>$ =newSyntaxTreeNode("factor");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
} |
var
{
	$<node>$ =newSyntaxTreeNode("factor");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
call
{
	$<node>$ =newSyntaxTreeNode("factor");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
NUMBER
{
	$<node>$ =newSyntaxTreeNode("factor");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
call:IDENTIFIER LPARENTHESE args RPARENTHESE
{
	$<node>$ =newSyntaxTreeNode("call");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
	SyntaxTreeNode_AddChild($<node>$, $<node>4);
}
;
args:arg_list
{
	$<node>$ =newSyntaxTreeNode("args");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
} |
epsilon
{
	$<node>$ =newSyntaxTreeNode("args");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
arg_list:arg_list COMMA expression 
{
	$<node>$ =newSyntaxTreeNode("arg-list");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
	SyntaxTreeNode_AddChild($<node>$, $<node>2);
	SyntaxTreeNode_AddChild($<node>$, $<node>3);
} |
expression
{
	$<node>$ =newSyntaxTreeNode("arg-list");
	SyntaxTreeNode_AddChild($<node>$, $<node>1);
}
;
epsilon:
{
	$<node>$ = newSyntaxTreeNode("epsilon");
}
%%

void yyerror(const char * s)
{
	// TODO: variables in Lab1 updates only in analyze() function in lexical_analyzer.l
	//       You need to move position updates to show error output below
	fprintf(stderr, "%s:%d syntax error for %s\n", s, lines, yytext);
}

/// \brief Syntax analysis from input file to output file
///
/// \param input basename of input file
/// \param output basename of output file
void syntax(const char * input, const char * output)
{
	gt = newSyntaxTree();

	char inputpath[256] = "./testcase/";
	char outputpath[256] = "./syntree/";
	strcat(inputpath, input);
	strcat(outputpath, output);

	if (!(yyin = fopen(inputpath, "r"))) {
		fprintf(stderr, "[ERR] Open input file %s failed.", inputpath);
		exit(1);
	}
	yyrestart(yyin);
	printf("[START]: Syntax analysis start for %s\n", input);
	FILE * fp = fopen(outputpath, "w+");
	if (!fp)	return;

	// yyerror() is invoked when yyparse fail. If you still want to check the return value, it's OK.
	// `while (!feof(yyin))` is not needed here. We only analyze once.
	yyparse();

	printf("[OUTPUT] Printing tree to output file %s\n", outputpath);
	printSyntaxTree(fp, gt);
	deleteSyntaxTree(gt);
	gt = 0;

	fclose(fp);
	printf("[END] Syntax analysis end for %s\n", input);
}

/// \brief starting function for testing syntax module.
///
/// Invoked in test_syntax.c
int syntax_main(int argc, char ** argv)
{
	char filename[50][256];
	char output_file_name[256];
	const char * suffix = ".syntax_tree";
	int fn = getAllTestcase(filename);
	for (int i = 0; i < fn; i++) {
			int name_len = strstr(filename[i], ".cminus") - filename[i];
			strncpy(output_file_name, filename[i], name_len);
			strcpy(output_file_name+name_len, suffix);
			syntax(filename[i], output_file_name);
	}
	return 0;
}
