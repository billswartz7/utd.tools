/* A Bison parser, made by GNU Bison 3.0.5.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018 Free Software Foundation, Inc.

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

#ifndef YY_RTLIL_FRONTEND_ILANG_YY_ILANG_PARSER_TAB_HH_INCLUDED
# define YY_RTLIL_FRONTEND_ILANG_YY_ILANG_PARSER_TAB_HH_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int rtlil_frontend_ilang_yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOK_ID = 258,
    TOK_VALUE = 259,
    TOK_STRING = 260,
    TOK_INT = 261,
    TOK_AUTOIDX = 262,
    TOK_MODULE = 263,
    TOK_WIRE = 264,
    TOK_WIDTH = 265,
    TOK_INPUT = 266,
    TOK_OUTPUT = 267,
    TOK_INOUT = 268,
    TOK_CELL = 269,
    TOK_CONNECT = 270,
    TOK_SWITCH = 271,
    TOK_CASE = 272,
    TOK_ASSIGN = 273,
    TOK_SYNC = 274,
    TOK_LOW = 275,
    TOK_HIGH = 276,
    TOK_POSEDGE = 277,
    TOK_NEGEDGE = 278,
    TOK_EDGE = 279,
    TOK_ALWAYS = 280,
    TOK_GLOBAL = 281,
    TOK_INIT = 282,
    TOK_UPDATE = 283,
    TOK_PROCESS = 284,
    TOK_END = 285,
    TOK_INVALID = 286,
    TOK_EOL = 287,
    TOK_OFFSET = 288,
    TOK_PARAMETER = 289,
    TOK_ATTRIBUTE = 290,
    TOK_MEMORY = 291,
    TOK_SIZE = 292,
    TOK_SIGNED = 293,
    TOK_UPTO = 294
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 48 "ilang_parser.y" /* yacc.c:1916  */

	char *string;
	int integer;
	YOSYS_NAMESPACE_PREFIX RTLIL::Const *data;
	YOSYS_NAMESPACE_PREFIX RTLIL::SigSpec *sigspec;
	std::vector<YOSYS_NAMESPACE_PREFIX RTLIL::SigSpec> *rsigspec;

#line 102 "../ilang_parser.tab.hh" /* yacc.c:1916  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE rtlil_frontend_ilang_yylval;

int rtlil_frontend_ilang_yyparse (void);

#endif /* !YY_RTLIL_FRONTEND_ILANG_YY_ILANG_PARSER_TAB_HH_INCLUDED  */
