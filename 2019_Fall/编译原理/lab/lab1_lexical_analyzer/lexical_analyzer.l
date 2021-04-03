%option noyywrap
%{
/*****************声明和选项设置  begin*****************/
#include <stdio.h>
#include <stdlib.h>

#include "lab1_lexical_analyzer/lexical_analyzer.h"
#include "common/common.h"
#include "syntax_tree/SyntaxTree.h"

#ifndef LAB1_ONLY
#include "syntax_analyzer.h"
#endif

int files_count;
int lines;
int pos_start;
int pos_end;

/*****************声明和选项设置  end*****************/

%}

commentPattern "/*"([^\*]|(\*)*[^\*/])*(\*)*"*/"
digitPattern [0-9]
numberPattern (0|[1-9]{digitPattern}*)
identifierPattern [a-zA-Z][a-zA-Z]*

%%

 /******************TODO*********************/
 /****请在此补全所有flex的模式与动作  start******/

"+" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return ADD; 
}
"-" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return SUB; 
}
"*" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return MUL; 
}
"/" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return DIV; 
}
"<" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return LT; 
}
"<=" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return LTE; 
}
">" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return GT; 
}
">=" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return GTE; 
}
"==" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return EQ; 
}
"!=" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return NEQ; 
}
"=" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return ASSIN; 
}
";" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return SEMICOLON; 
}
"," {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return COMMA; 
}
"(" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return LPARENTHESE; 
}
")" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return RPARENTHESE; 
}
"[" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return LBRACKET; 
}
"]" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return RBRACKET; 
}
"{" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return LBRACE; 
}
"}" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return RBRACE; 
}
"else" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return ELSE; 
}
"if" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return IF; 
}
"int" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return INT; 
}
"return" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return RETURN; 
}
"void" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return VOID; 
}
"while" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return WHILE; 
}
[a-zA-Z][a-zA-Z]* {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return IDENTIFIER; 
}
(0|[1-9][0-9]*) {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return NUMBER; 
}
"[]" {
	#ifndef LAB1_ONLY
	yylval.node=newSyntaxTreeNode(yytext);
	#endif
	return ARRAY; 
}
"\n" {
	lines++;
	#ifdef LAB1_ONLY
		return EOL; 
	#endif
}
"/*"([^\*]|(\*)*[^\*/])*(\*)*"*/" {
	#ifdef LAB1_ONLY
		return COMMENT; 
	#endif
}
([ ]|"\t") {
	#ifdef LAB1_ONLY
		return BLANK; 
	#endif
}
. {return ERROR;}
 /****  end******/
%%

 /****请在此补全所有flex的模式与动作  end******/

/****************C代码 start*************/

/// \brief analysize a *.cminus file
///
///	\param input_file_name
/// \param output_file_name
void analyzer(char* input_file_name, char* output_file_name){
	lines = 1;
	pos_start = 1;
	pos_end = 1;
	char input_path[256] = "./testcase/";
	strcat(input_path, input_file_name);
	char output_path[256] = "./tokens/";
	strcat(output_path, output_file_name);
	if(!(yyin = fopen(input_path,"r"))){
		printf("[ERR] No input file\n");
		exit(1);
	}
	printf("[START]: Read from: %s\n", input_file_name);
	FILE *fp = fopen(output_path,"w+");

	int token;
	while(token = yylex()){
		pos_start = pos_end;
		pos_end += strlen(yytext);
		switch(token){
			case ERROR:
				fprintf(fp, "[ERR]: unable to analysize %s at %d line, from %d to %d\n", yytext, lines, pos_start, pos_end);
				break;
			case COMMENT:
			{
				int k=0;
			    for(int i=0;i<strlen(yytext);i++)
				{
					if(yytext[i]=='\n')
					{
						lines++;
						pos_start=1;
						pos_end=1;
						k=i+1;
					}
				}
				pos_end=pos_start+strlen(yytext)-k;			
				break;
			}
			case BLANK:
				break;
			case EOL:
				pos_start = 1,pos_end = 1;
				break;
			case NUMBER:
				fprintf(fp, "%d\t%d\t%d\t%d\t%d\n",atoi(yytext), token, lines, pos_start, pos_end);
				break;
			default :
				fprintf(fp, "%s\t%d\t%d\t%d\t%d\n",yytext, token, lines, pos_start, pos_end);
		}
	}
	fclose(fp);
	printf("[END]: Analysis completed.\n");
}



/// \brief process all *.cminus file
///
/// note that: use relative path for all i/o operations
int lex_main(int argc, char **argv){
	char filename[50][256];
	char output_file_name[256];
	char suffix[] = ".tokens";
	files_count = getAllTestcase(filename);
	for(int i = 0; i < files_count; i++){
	    strncpy(output_file_name,filename[i],strlen(filename[i])-7);
		output_file_name[strlen(filename[i])-7]='\0';
		strcat(output_file_name,suffix);
	    analyzer(filename[i],output_file_name);
	}

	return 0;
}
/****************C代码 end*************/
