/* PL*/

%{
#include "hashtable/hashtbl.h"
#include <stdio.h>
#include <stdlib.h>

#define max_parsing_errors 5

extern FILE *yyin;
extern int yylineno;
extern int yylex(); 

int parsing_errors = 0;
int scope = 0;

HASHTBL *hashtbl;

void yyerror(const char *err);
%}

%define parse.error verbose //%error-verbose

%union {
    int   intval;
    float realval;
    char  charval;
    char* strval;
}

%token  T_PROGRAM       "Program"
%token  T_CONST         "Const"
%token  T_TYPE          "Type"
%token  T_ARRAY         "Array"
%token  T_OF            "of"
%token  T_VAR           "var"
%token  T_FORWARD       "forward"
%token  T_FUNCTION      "function"
%token  T_PROCEDURE     "procedure"
%token  T_INTEGER       "integer"
%token  T_REAL          "real"
%token  T_BOOLEAN       "boolean"
%token  T_CHAR          "char"
%token  T_STRING        "string"
%token  T_BEGIN         "begin"
%token  T_END           "end"
%token  T_IF            "if"
%token  T_THEN          "then"
%token  T_ELSE          "else"
%token  T_CASE          "case"
%token  T_OTHERWISE     "otherwise"
%token  T_WHILE         "while"
%token  T_DO            "do"
%token  T_FOR           "for"
%token  T_DOWNTO        "downto"
%token  T_TO            "to"
%token  T_READ          "read"      
%token  T_WRITE         "write"
%token  T_LENGTH        "length"


%token  <strval>  T_ID  "id"


%token  <intval>    T_ICONST    "iconst"
%token  <floatval>  T_RCONST    "rconst"
%token  <intval>    T_BCONST    "bconst"
%token  <charval>   T_CCONST    "cconst"
%token  <strval>    T_SCONST    "sconst"


%token  T_RELOP         "> or >= or < or <= or <>"
%token  T_ADDOP         "+ or -"
%token  T_OROP          "OR"
%token  T_MULDIVANDOP   "* or / or DIV or MOD or AND"
%token  T_NOTOP         "NOT"


%token  T_LPAREN        "("
%token  T_RPAREN        ")"
%token  T_SEMI          ";"
%token  T_DOT           "."
%token  T_COMMA         ","
%token  T_EQU           "="
%token  T_COLON         ":"
%token  T_LBRACK        "["
%token  T_RBRACK        "]"
%token  T_ASSIGN        ":="
%token  T_DOTDOT        ".."

%token  T_EOF 0         "EOF"


%nonassoc T_RELOP T_ASSIGN T_EQU
%left T_ADDOP T_OROP
%left T_MULDIVANDOP
%left T_NOTOP
%left T_LPAREN T_RPAREN T_LBRACK T_RBRACK

%nonassoc NO_ELSE
%nonassoc T_ELSE

%%

program : header declarations subprograms comp_statement T_DOT
                                                            ;
header : T_PROGRAM T_ID T_SEMI                                                          {hashtbl_insert(hashtbl, $2, NULL ,scope);}     
                                                            ;                          

declarations : constdefs typedefs vardefs;

constdefs : T_CONST constant_defs T_SEMI
                                                            | %empty
                                                            ;

constant_defs : constant_defs T_SEMI T_ID  T_EQU expression                             {hashtbl_insert(hashtbl, $3, NULL ,scope);} 
                                                            | T_ID  T_EQU expression    {hashtbl_insert(hashtbl, $1, NULL ,scope);}    
                                                            ;

expression : expression T_RELOP expression
                                                            | expression T_EQU expression
                                                            | expression T_OROP expression
                                                            | expression T_ADDOP expression
                                                            | expression T_MULDIVANDOP expression
                                                            | T_ADDOP expression
                                                            | T_NOTOP expression
                                                            | variable
                                                            | T_ID  T_LPAREN expressions T_RPAREN    {hashtbl_insert(hashtbl, $1, NULL ,scope);} 
                                                            | T_LENGTH T_LPAREN expression T_RPAREN
                                                            | constant
                                                            | T_LPAREN expression T_RPAREN
                                                            ;

variable : T_ID                                                                                     {hashtbl_insert(hashtbl, $1, NULL ,scope);} 
                                                            | variable T_LBRACK  expressions T_RBRACK 
                                                            ;

expressions : expressions T_COMMA expression
                                                            | expression
                                                            ;

constant : T_ICONST
                                                            | T_RCONST
                                                            | T_BCONST
                                                            | T_CCONST
                                                            | T_SCONST
                                                            ;

typedefs : T_TYPE type_defs T_SEMI
                                                            | %empty
                                                            ;

type_defs : type_defs T_SEMI T_ID  T_EQU type_def                                       {hashtbl_insert(hashtbl, $3, NULL ,scope);} 
                                                            | T_ID  T_EQU type_def      {hashtbl_insert(hashtbl, $1, NULL ,scope);}
                                                            ;

type_def : T_ARRAY T_LBRACK  dims T_RBRACK  T_OF typename
                                                            | T_LPAREN identifiers T_RPAREN
                                                            | limit T_DOTDOT limit
                                                            ;

dims : dims T_COMMA limits
                                                            | limits
                                                            ;

limits : limit T_DOTDOT limit
                                                            | T_ID          {hashtbl_insert(hashtbl, $1, NULL ,scope);}
                                                            ;

limit : sign T_ICONST
                                                            | T_CCONST
                                                            | T_BCONST
                                                            | T_ADDOP T_ID  {hashtbl_insert(hashtbl, $2, NULL ,scope);} 
                                                            | T_ID          {hashtbl_insert(hashtbl, $1, NULL ,scope);}
                                                            ;

sign : T_ADDOP | %empty
                                                            ;

typename : standard_type
                                                            | T_ID      {hashtbl_insert(hashtbl, $1, NULL ,scope);}
                                                            ;

standard_type : T_INTEGER | T_REAL | T_BOOLEAN | T_CHAR | T_STRING vardefs : T_VAR variable_defs T_SEMI
                                                            | %empty
                                                            ;

variable_defs : variable_defs T_SEMI identifiers T_COLON typename
                                                            | identifiers T_COLON typename
                                                            ;

identifiers : identifiers T_COMMA T_ID                                  {hashtbl_insert(hashtbl, $3, NULL ,scope);}
                                                            | T_ID      {hashtbl_insert(hashtbl, $1, NULL ,scope);}
                                                            ;

subprograms : subprograms subprogram T_SEMI
                                                            | %empty
                                                            ;

subprogram : sub_header  T_SEMI T_FORWARD         
                                                            | sub_header T_SEMI {scope++;} declarations subprograms comp_statement {hashtbl_get(hashtbl,scope); scope--;} 
                                                            ;

sub_header : T_FUNCTION T_ID  formal_parameters T_COLON typename                                    {hashtbl_insert(hashtbl, $2, NULL ,scope);}
                                                            | T_PROCEDURE T_ID  formal_parameters   {hashtbl_insert(hashtbl, $2, NULL ,scope);}
                                                            | T_FUNCTION T_ID                       {hashtbl_insert(hashtbl, $2, NULL ,scope);}
                                                            ;

formal_parameters : T_LPAREN parameter_list T_RPAREN
                                                            | %empty
                                                            ;

parameter_list : parameter_list T_SEMI pass identifiers T_COLON typename
                                                            | pass identifiers T_COLON typename 
                                                            ;

pass : T_VAR | %empty;

comp_statement : T_BEGIN statements T_END;

statements : statements T_SEMI statement
                                                            | statement;

statement : assignment
                                                            | if_statement
                                                            | while_statement
                                                            | for_statement
                                                            | subprogram_call
                                                            | io_statement
                                                            | comp_statement
                                                            | %empty 
                                                            ;

assignment : variable T_ASSIGN expression;

if_statement : T_IF expression T_THEN{scope++;} statement{hashtbl_get(hashtbl,scope); scope--;} if_tail;

if_tail : T_ELSE{scope++;} statement {hashtbl_get(hashtbl,scope); scope--;}
                                                            | %empty %prec NO_ELSE
                                                            ;
 
while_statement : T_WHILE expression T_DO{scope++;} statement{hashtbl_get(hashtbl,scope); scope--;}; 

for_statement : T_FOR T_ID  T_ASSIGN iter_space T_DO{scope++;} statement{hashtbl_get(hashtbl,scope); scope--;}  {hashtbl_insert(hashtbl, $2, NULL ,scope);}
                                                            ;

iter_space : expression T_TO expression
                                                            | expression T_DOWNTO expression
                                                            ;

subprogram_call : T_ID                                                                                  {hashtbl_insert(hashtbl, $1, NULL ,scope);}
                                                            | T_ID  T_LPAREN expressions T_RPAREN       {hashtbl_insert(hashtbl, $1, NULL ,scope);}
                                                            ;

io_statement : T_READ T_LPAREN read_list T_RPAREN
                                                            | T_WRITE T_LPAREN write_list T_RPAREN
                                                            ;

read_list : read_list T_COMMA read_item
                                                            | read_item 
                                                            ;

read_item : variable;

write_list : write_list T_COMMA write_item
                                                            | write_item
                                                            ;

write_item : expression;


%%

int main(int argc, char* argv[]){

    int token;
    scope = 0;
    yyin = fopen(argv[1], "r");
    
    if(!(hashtbl = hashtbl_create(10,NULL))){
		perror("Can't Create hashtable.\nCompiler exiting...\n");
		return -2;
	}

    if(yyin == NULL){
        printf("Failed in file opening: %s",argv[1]);
        return 1;
    }

    printf("\n[Line 1]\n");

    yyparse();

    fclose(yyin);

    return 0; 

}

void yyerror(const char *err){

    if(parsing_errors==max_parsing_errors){
        printf("\n Max error limit reached(%d)\n", max_parsing_errors);
        exit(EXIT_FAILURE);
    }

    parsing_errors++;
    printf("\n[Line %d] %s\n", yylineno, err);
}

