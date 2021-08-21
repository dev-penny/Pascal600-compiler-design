
/* statements */
%{
    #include "lexer_Pasc600.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <unistd.h>
    #include <math.h>
    #include <string.h>

    int error_count = 0;
    char str_buf[256];
    extern int yylval;

    void yyerror(const char* err);
%}

%option case-insensitive
%option yylineno
%option noyywrap
%x STRING
%x COMMENT

LETTER      [a-zA-Z]
DIGIT       [0-9]
NZNUMBER    [1-9][0-9]*|0
CHARACTER   {LETTER}|{DIGIT}
WHITESPACE  [ \t]


RCONST      0X|0x([1-9A-F][0-9A-F]*)?\.[0-9A-F]+|([1-9][0-9]*)*"."[0-9]?("E"[+-]?[1-9]+[0-9]*)*|[^+-][1-9][0-9]*"E"[+-]?[0-9]+
ICONST      0X[A-F1-9][A-F0-9]*|[1-9][0-9]*|0
BCONST      "TRUE"|"FALSE"
CCONST      \'(.|\\[nftrbv])\'
ID          _?{LETTER}(({LETTER}|{DIGIT}|_({LETTER}|{DIGIT}))+)?





/* 2nd part , change part with %% -> rules (regular expressions) */
%%

"program"       { printf("\n[KEYWORD: program]\n"); return T_PROGRAM; }
"const"         { printf("\n[KEYWORD: const]\n"); return T_CONST; }
"type"          { printf("\n[KEYWORD: type]\n"); return T_TYPE; }
"array"         { printf("\n[KEYWORD: array]\n"); return T_ARRAY; }
"of"            { printf("\n[KEYWORD: of]\n"); return T_OF; }
"var"           { printf("\n[KEYWORD: var]\n"); return T_VAR; }
"forward"       { printf("\n[KEYWORD: forward]\n"); return T_FORWARD; }
"function"      { printf("\n[KEYWORD: function]\n"); return T_FUNCTION; }
"procedure"     { printf("\n[KEYWORD: procedure]\n"); return T_PROCEDURE; }
"integer"       { printf("\n[KEYWORD: integer]\n"); return T_INTEGER; }
"real"          { printf("\n[KEYWORD: real]\n"); return T_REAL; }
"boolean"       { printf("\n[KEYWORD: boolean]\n"); return T_BOOLEAN; }
"char"          { printf("\n[KEYWORD: charr]\n"); return T_CHAR; }
"string"        { printf("\n[KEYWORD: string]\n"); return T_STRING; }
"begin"         { printf("\n[KEYWORD: begin]\n"); return T_BEGIN; }
"end"           { printf("\n[KEYWORD: end]\n"); return T_END; }
"if"            { printf("\n[KEYWORD: if]\n"); return T_IF; }
"then"          { printf("\n[KEYWORD: then]\n"); return T_THEN; }
"else"          { printf("\n[KEYWORD: else]\n"); return T_ELSE; }
"case"          { printf("\n[KEYWORD: case]\n"); return T_CASE; }
"otherwise"     { printf("\n[KEYWORD: otherwise]\n"); return T_OTHERWISE; }
"while"         { printf("\n[KEYWORD: while]\n"); return T_WHILE; }
"do"            { printf("\n[KEYWORD: do]\n"); return T_DO; }
"for"           { printf("\n[KEYWORD: for]\n"); return T_FOR; }
"downto"        { printf("\n[KEYWORD: downto]\n"); return T_DOWNTO; }
"to"            { printf("\n[KEYWORD: to]\n"); return T_TO; }
"read"          { printf("\n[KEYWORD: read]\n"); return T_READ; }
"write"         { printf("\n[KEYWORD: write]\n"); return T_WRITE; }
"length"        { printf("\n[KEYWORD: length]\n"); return T_LENGTH; }

">"|">="|"<"|"<="       { printf("\nOPERATOR: %s\n",yytext); return T_RELOP; }
"+"|"-"                 { printf("\nADDOP -> %s\n", yytext); return T_ADDOP; }
"OR"                    { printf("\nMULOP -> %s\n", yytext); return T_OROP; }
"*"|"/"|"DIV"|"MOD"|"AND"     { printf("\nDIVMODOP -> %s\n", yytext); return T_MULDIVANDOP; }
"NOT"               { printf("\nNOTOP -> %s\n", yytext); return T_NOTOP; }

"("                 { printf("\nLPAREN\n"); return T_LPAREN; }
")"                 { printf("\nRPAREN\n"); return T_RPAREN; }
";"                 { printf("\nSEMI\n"); return T_SEMI; }
"."                 { printf("\nDot\n"); return T_DOT; }
","                 { printf("\nCOMMA\n"); return T_COMMA; }
"="                 { printf("\nASSIGN\n"); return T_EQU; }
"["                 { printf("\nLBRACK\n"); return T_LBRACK; }
"]"                 { printf("\nRBRACK\n"); return T_RBRACK; }
":"                 { printf("\nASSIGN\n"); return T_COLON; }
":="                { printf("\nASSIGN\n"); return T_ASSIGN; }
".."                { printf("\nDotDot\n"); return T_DOTDOT; }

{BCONST}            { printf("\nBCONST -> %s\n", yytext); return T_BCONST; }
{RCONST}            { printf("\nRCONST -> %s\n", yytext); return T_RCONST; }
{CCONST}            { printf("\nCCONST -> %s\n",yytext); return T_CCONST;}
{ICONST}            { printf("\nICONST -> %s\n", yytext); return T_ICONST; }
{ID}                { printf("\nID -> %s\n", yytext); return T_ID; }

\"                      { strcpy(str_buf, ""); BEGIN(STRING); }
<STRING>\"              { printf("\nSCONST -> %s\n", str_buf); BEGIN(INITIAL); return T_SCONST; }
<STRING>\n              { yyerror("Line feed in string without \\"); }
<STRING>\\n                                       {*str_buf++ = '\n';}
<STRING>\\f                                       {*str_buf++ = '\f';}
<STRING>\\t                                       {*str_buf++ = '\t';}
<STRING>\\r                                       {*str_buf++ = '\r';}
<STRING>\\b                                       {*str_buf++ = '\b';}
<STRING>\\v                                       {*str_buf++ = '\v';}
<STRING>\\\\                                      {*str_buf++ = '\\';}
<STRING>\\\"                                      {*str_buf++ = '"';}
<STRING>\\{CHARACTER}                             {*str_buf++ = yytext[1];}
<STRING>(\n|\r\n)                                 {yyerror("String Error"); yyless(1);}

<STRING>[^\\\n\"]+                                {char *yptr = yytext;  while ( *yptr ) *str_buf++ = *yptr++;}
<STRING>(\\.|[^"\\])    { strcat(str_buf, yytext); }



<STRING>(\\\n)+         { }
<STRING><<EOF>>         { yyerror("EOF in string"); }
<STRING>.               { yyerror("Unknown character in string"); }

"{"                     { BEGIN(COMMENT); }
<COMMENT>"}"            { BEGIN(INITIAL); }
<COMMENT>\n             { printf("\n[Line %d]\n", yylineno); }
<COMMENT>.              { }
<COMMENT>(\\\n)+        { }
<COMMENT><<EOF>>        { }

{WHITESPACE}        { /* ignore spaces*/ }
\n                  { printf("\n[Line %d]\n", yylineno); } 
<<EOF>>             { printf("\nEOF\n"); return T_EOF; }
.                   { yyerror("Unrecognised character"); }

%%

//user functions

int main(int argc, char* argv[]){

    int token;
    yyin = fopen(argv[1], "r");

    if(yyin == NULL){
        printf("Failed in file opening: %s",argv[1]);
        return 1;
    }

    printf("\n[Line 1]\n");

    do {
        token = yylex();
    }while (token != T_EOF);

    fclose(yyin);

}

void yyerror(const char* err) {

    error_count++;

    printf("\n[ERROR - Line %d]: %s (%s)\n", yylineno, err,yytext);

    if (error_count == 5) {
        printf("\nError count limit reached. Exiting...\n");
        exit(EXIT_FAILURE);
    }
}