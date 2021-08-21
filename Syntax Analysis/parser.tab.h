/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_EOF = 0,
    T_PROGRAM = 258,
    T_CONST = 259,
    T_TYPE = 260,
    T_ARRAY = 261,
    T_OF = 262,
    T_VAR = 263,
    T_FORWARD = 264,
    T_FUNCTION = 265,
    T_PROCEDURE = 266,
    T_INTEGER = 267,
    T_REAL = 268,
    T_BOOLEAN = 269,
    T_CHAR = 270,
    T_STRING = 271,
    T_BEGIN = 272,
    T_END = 273,
    T_IF = 274,
    T_THEN = 275,
    T_ELSE = 276,
    T_CASE = 277,
    T_OTHERWISE = 278,
    T_WHILE = 279,
    T_DO = 280,
    T_FOR = 281,
    T_DOWNTO = 282,
    T_TO = 283,
    T_READ = 284,
    T_WRITE = 285,
    T_LENGTH = 286,
    T_ID = 287,
    T_ICONST = 288,
    T_RCONST = 289,
    T_BCONST = 290,
    T_CCONST = 291,
    T_SCONST = 292,
    T_RELOP = 293,
    T_ADDOP = 294,
    T_OROP = 295,
    T_MULDIVANDOP = 296,
    T_NOTOP = 297,
    T_LPAREN = 298,
    T_RPAREN = 299,
    T_SEMI = 300,
    T_DOT = 301,
    T_COMMA = 302,
    T_EQU = 303,
    T_COLON = 304,
    T_LBRACK = 305,
    T_RBRACK = 306,
    T_ASSIGN = 307,
    T_DOTDOT = 308,
    NO_ELSE = 309
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 24 "parser.y" /* yacc.c:1909  */

    int   intval;
    float realval;
    char  charval;
    char* strval;

#line 117 "parser.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
