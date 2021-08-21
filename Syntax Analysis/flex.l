/* PL */

/* statements */
%{
    #define DEBUG_MODE 0
    //#include "lexer_Pasc600.h"
    #include "parser.tab.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <unistd.h>
    #include <math.h>
    #include <string.h>
    

    int error_count = 0;
    char str_buf[256];

    extern void yyerror(const char* err);
    int strtoint(const char *str);
    char specialCharReader(char* yytext);
    float strtoreal(const char* str);
    char specialCharReader(char* yytext);

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

"program"       { if(DEBUG_MODE) printf("\n[KEYWORD: program]\n"); return T_PROGRAM; }
"const"         { if(DEBUG_MODE) printf("\n[KEYWORD: const]\n"); return T_CONST; }
"type"          { if(DEBUG_MODE) printf("\n[KEYWORD: type]\n"); return T_TYPE; }
"array"         { if(DEBUG_MODE) printf("\n[KEYWORD: array]\n"); return T_ARRAY; }
"of"            { if(DEBUG_MODE) printf("\n[KEYWORD: of]\n"); return T_OF; }
"var"           { if(DEBUG_MODE) printf("\n[KEYWORD: var]\n"); return T_VAR; }
"forward"       { if(DEBUG_MODE) printf("\n[KEYWORD: forward]\n"); return T_FORWARD; }
"function"      { if(DEBUG_MODE) printf("\n[KEYWORD: function]\n"); return T_FUNCTION; }
"procedure"     { if(DEBUG_MODE) printf("\n[KEYWORD: procedure]\n"); return T_PROCEDURE; }
"integer"       { if(DEBUG_MODE) printf("\n[KEYWORD: integer]\n"); return T_INTEGER; }
"real"          { if(DEBUG_MODE) printf("\n[KEYWORD: real]\n"); return T_REAL; }
"boolean"       { if(DEBUG_MODE) printf("\n[KEYWORD: boolean]\n"); return T_BOOLEAN; }
"char"          { if(DEBUG_MODE) printf("\n[KEYWORD: charr]\n"); return T_CHAR; }
"string"        { if(DEBUG_MODE) printf("\n[KEYWORD: string]\n"); return T_STRING; }
"begin"         { if(DEBUG_MODE) printf("\n[KEYWORD: begin]\n"); return T_BEGIN; }
"end"           { if(DEBUG_MODE) printf("\n[KEYWORD: end]\n"); return T_END; }
"if"            { if(DEBUG_MODE) printf("\n[KEYWORD: if]\n"); return T_IF; }
"then"          { if(DEBUG_MODE) printf("\n[KEYWORD: then]\n"); return T_THEN; }
"else"          { if(DEBUG_MODE) printf("\n[KEYWORD: else]\n"); return T_ELSE; }
"case"          { if(DEBUG_MODE) printf("\n[KEYWORD: case]\n"); return T_CASE; }
"otherwise"     { if(DEBUG_MODE) printf("\n[KEYWORD: otherwise]\n"); return T_OTHERWISE; }
"while"         { if(DEBUG_MODE) printf("\n[KEYWORD: while]\n"); return T_WHILE; }
"do"            { if(DEBUG_MODE) printf("\n[KEYWORD: do]\n"); return T_DO; }
"for"           { if(DEBUG_MODE) printf("\n[KEYWORD: for]\n"); return T_FOR; }
"downto"        { if(DEBUG_MODE) printf("\n[KEYWORD: downto]\n"); return T_DOWNTO; }
"to"            { if(DEBUG_MODE) printf("\n[KEYWORD: to]\n"); return T_TO; }
"read"          { if(DEBUG_MODE) printf("\n[KEYWORD: read]\n"); return T_READ; }
"write"         { if(DEBUG_MODE) printf("\n[KEYWORD: write]\n"); return T_WRITE; }
"length"        { if(DEBUG_MODE) printf("\n[KEYWORD: length]\n"); return T_LENGTH; }

">"|">="|"<"|"<="       { if(DEBUG_MODE) printf("\nOPERATOR: %s\n",yytext); return T_RELOP; }
"+"|"-"                 { if(DEBUG_MODE) printf("\nADDOP -> %s\n", yytext); return T_ADDOP; }
"OR"                    { if(DEBUG_MODE) printf("\nMULOP -> %s\n", yytext); return T_OROP; }
"*"|"/"|"DIV"|"MOD"|"AND"     { if(DEBUG_MODE) printf("\nDIVMODOP -> %s\n", yytext); return T_MULDIVANDOP; }
"NOT"               { if(DEBUG_MODE) printf("\nNOTOP -> %s\n", yytext); return T_NOTOP; }

"("                 { if(DEBUG_MODE) printf("\nLPAREN\n"); return T_LPAREN; }
")"                 { if(DEBUG_MODE) printf("\nRPAREN\n"); return T_RPAREN; }
";"                 { if(DEBUG_MODE) printf("\nSEMI\n"); return T_SEMI; }
"."                 { if(DEBUG_MODE) printf("\nDot\n"); return T_DOT; }
","                 { if(DEBUG_MODE) printf("\nCOMMA\n"); return T_COMMA; }
"="                 { if(DEBUG_MODE) printf("\nASSIGN\n"); return T_EQU; }
"["                 { if(DEBUG_MODE) printf("\nLBRACK\n"); return T_LBRACK; }
"]"                 { if(DEBUG_MODE) printf("\nRBRACK\n"); return T_RBRACK; }
":"                 { if(DEBUG_MODE) printf("\nASSIGN\n"); return T_COLON; }
":="                { if(DEBUG_MODE) printf("\nASSIGN\n"); return T_ASSIGN; }
".."                { if(DEBUG_MODE) printf("\nDotDot\n"); return T_DOTDOT; }

{BCONST}            { if(DEBUG_MODE) printf("\nBCONST -> %s\n", yytext);     yylval.intval  =  strtoint(yytext);               return T_BCONST; }
{RCONST}            { if(DEBUG_MODE) printf("\nRCONST -> %s\n", yytext);     yylval.realval =  strtoreal(yytext);              return T_RCONST; }
{CCONST}            { if(DEBUG_MODE) printf("\nCCONST -> %s\n", yytext);     yylval.charval =  specialCharReader(yytext);      return T_CCONST; }
{ICONST}            { if(DEBUG_MODE) printf("\nICONST -> %s\n", yytext);     yylval.intval  =  strtoint(yytext);               return T_ICONST; }
{ID}                { if(DEBUG_MODE) printf("\nID -> %s\n", yytext);         yylval.strval  =  strdup(yytext);                 return T_ID; }


\"                      { strcpy(str_buf, "");  BEGIN(STRING); } //memset(str_esc, 0 , sizeof(str_esc));
<STRING>\"              { if(DEBUG_MODE) printf("\nSCONST -> %s\n", str_buf); BEGIN(INITIAL); yylval.strval = strdup(str_buf); return T_SCONST; }
<STRING>\n              { yyerror("Line feed in string without \\"); }
<STRING>(\\.|[^"\\])    { strcat(str_buf, yytext); }
<STRING>(\\\n)+         { }
<STRING><<EOF>>         { yyerror("EOF in string"); }
<STRING>.               { yyerror("Unknown character in string"); }

"{"                     { BEGIN(COMMENT); }
<COMMENT>"}"            { BEGIN(INITIAL); }
<COMMENT>\n             { if(DEBUG_MODE) printf("\n[Line %d]\n", yylineno); }
<COMMENT>.              { }
<COMMENT>(\\\n)+        { }
<COMMENT><<EOF>>        { }

{WHITESPACE}        { /* ignore spaces*/ }
\n                  { if(DEBUG_MODE) printf("\n[Line %d]\n", yylineno); } 
<<EOF>>             { if(DEBUG_MODE) printf("\nEOF\n"); return T_EOF; }
.                   { yyerror("Unrecognised character"); }

%%
/*
<STRING>\"              { stresc(str_buf, str_esc); printf("\nSCONST -> %s\n", str_buf); BEGIN(INITIAL);     yylval.strval = strdup(str_esc);       return T_SCONST; }

*/


char specialCharReader(char* yytext){
    char str_b[256];

    if(strlen(yytext) == 2){
        if(strcmp(yytext, "\\n") == 0)
            strcat(str_b, "\n");
        else if(strcmp(yytext, "\\t") == 0)
            strcat(str_b, "\t");
        else if(strcmp(yytext, "\\r") == 0)
            strcat(str_b, "\r");    
        else if(strcmp(yytext, "\\f") == 0)
            strcat(str_b, "\f");
        else if(strcmp(yytext, "\\b") == 0)
            strcat(str_b, "\b");
        else if(strcmp(yytext, "\\v") == 0)
            strcat(str_b, "\v");
        else
            strcat(str_b, &yytext[1]);

        return *str_b;
    }
    else
        return *yytext;
} 

int strtoint(const char *str) {
    if (strncmp(str, "0O", 2) == 0) return (int) strtol(&str[2], NULL, 8);
    else if (strncmp(str, "0X", 2)==0) return (int) strtol(&str[2], NULL, 16);
    else return (int) strtol(str, NULL, 10);
}

float strtoreal(const char* str) {

    int i, base;
    float res;
    char *integer, *fractional; // part

    if (!strncmp(str, "0B", 2) || !strncmp(str, "0b", 2)) { base = 2; res = strtol(&str[2], &integer, 2); }
    else if (!strncmp(str, "0O", 2) || !strncmp(str, "0o", 2)) { base = 8; res = strtol(&str[2], &integer, 8); }
    else if (!strncmp(str, "0X", 2) || !strncmp(str, "0x", 2)) { base = 16; res = strtol(&str[2], &integer, 16); }
    else { base = 10; }

    if (base != 10) {
        for (i = 1; i < strlen(integer); ++i) {
            res += (integer[i] <= '9') ? (integer[i] - '0') * (1 / pow(base, i)) : (integer[i] - 'A' + 10) * (1 / pow(base, i));
        }
    } else {
        if (strchr(str, '.')) {
            res = strtol(str, &integer, 10);
            strtol(&integer[1], &fractional, 10);

            for (i = 1; i < strlen(integer) - strlen(fractional); ++i) res += (integer[i] - '0') * (1 / pow(base, i));

            if (strchr(fractional, '+')) res *= pow(10, strtol(&fractional[2], NULL, 10));
            else if (strchr(fractional, '-')) res *= pow(10, strtol(&fractional[2], NULL, 10) * -1);
            else res *= pow(10, strtol(&fractional[1], NULL, 10));
        } else {
            res = strtol(str, &fractional, 10);

            if (strchr(fractional, '+')) res *= pow(10, strtol(&fractional[2], NULL, 10));
            else if (strchr(fractional, '-')) res *= pow(10, strtol(&fractional[2], NULL, 10) * -1);
            else res *= pow(10, strtol(&fractional[1], NULL, 10));
        }
    }

    return res;

}