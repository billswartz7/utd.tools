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

#ifndef YY_FRONTEND_VERILOG_YY_VERILOG_PARSER_TAB_HH_INCLUDED
# define YY_FRONTEND_VERILOG_YY_VERILOG_PARSER_TAB_HH_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int frontend_verilog_yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOK_STRING = 258,
    TOK_ID = 259,
    TOK_CONSTVAL = 260,
    TOK_REALVAL = 261,
    TOK_PRIMITIVE = 262,
    ATTR_BEGIN = 263,
    ATTR_END = 264,
    DEFATTR_BEGIN = 265,
    DEFATTR_END = 266,
    TOK_MODULE = 267,
    TOK_ENDMODULE = 268,
    TOK_PARAMETER = 269,
    TOK_LOCALPARAM = 270,
    TOK_DEFPARAM = 271,
    TOK_PACKAGE = 272,
    TOK_ENDPACKAGE = 273,
    TOK_PACKAGESEP = 274,
    TOK_INPUT = 275,
    TOK_OUTPUT = 276,
    TOK_INOUT = 277,
    TOK_WIRE = 278,
    TOK_REG = 279,
    TOK_LOGIC = 280,
    TOK_INTEGER = 281,
    TOK_SIGNED = 282,
    TOK_ASSIGN = 283,
    TOK_ALWAYS = 284,
    TOK_INITIAL = 285,
    TOK_BEGIN = 286,
    TOK_END = 287,
    TOK_IF = 288,
    TOK_ELSE = 289,
    TOK_FOR = 290,
    TOK_WHILE = 291,
    TOK_REPEAT = 292,
    TOK_DPI_FUNCTION = 293,
    TOK_POSEDGE = 294,
    TOK_NEGEDGE = 295,
    TOK_OR = 296,
    TOK_AUTOMATIC = 297,
    TOK_CASE = 298,
    TOK_CASEX = 299,
    TOK_CASEZ = 300,
    TOK_ENDCASE = 301,
    TOK_DEFAULT = 302,
    TOK_FUNCTION = 303,
    TOK_ENDFUNCTION = 304,
    TOK_TASK = 305,
    TOK_ENDTASK = 306,
    TOK_SPECIFY = 307,
    TOK_ENDSPECIFY = 308,
    TOK_SPECPARAM = 309,
    TOK_GENERATE = 310,
    TOK_ENDGENERATE = 311,
    TOK_GENVAR = 312,
    TOK_REAL = 313,
    TOK_SYNOPSYS_FULL_CASE = 314,
    TOK_SYNOPSYS_PARALLEL_CASE = 315,
    TOK_SUPPLY0 = 316,
    TOK_SUPPLY1 = 317,
    TOK_TO_SIGNED = 318,
    TOK_TO_UNSIGNED = 319,
    TOK_POS_INDEXED = 320,
    TOK_NEG_INDEXED = 321,
    TOK_ASSERT = 322,
    TOK_ASSUME = 323,
    TOK_RESTRICT = 324,
    TOK_COVER = 325,
    TOK_PROPERTY = 326,
    TOK_ENUM = 327,
    TOK_TYPEDEF = 328,
    TOK_RAND = 329,
    TOK_CONST = 330,
    TOK_CHECKER = 331,
    TOK_ENDCHECKER = 332,
    TOK_EVENTUALLY = 333,
    TOK_INCREMENT = 334,
    TOK_DECREMENT = 335,
    TOK_UNIQUE = 336,
    TOK_PRIORITY = 337,
    OP_LOR = 338,
    OP_LAND = 339,
    OP_NOR = 340,
    OP_XNOR = 341,
    OP_NAND = 342,
    OP_EQ = 343,
    OP_NE = 344,
    OP_EQX = 345,
    OP_NEX = 346,
    OP_LE = 347,
    OP_GE = 348,
    OP_SHL = 349,
    OP_SHR = 350,
    OP_SSHL = 351,
    OP_SSHR = 352,
    OP_POW = 353,
    UNARY_OPS = 354,
    FAKE_THEN = 355
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 97 "verilog_parser.y" /* yacc.c:1916  */

	std::string *string;
	struct YOSYS_NAMESPACE_PREFIX AST::AstNode *ast;
	std::map<std::string, YOSYS_NAMESPACE_PREFIX AST::AstNode*> *al;
	bool boolean;

#line 162 "../verilog_parser.tab.hh" /* yacc.c:1916  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE frontend_verilog_yylval;

int frontend_verilog_yyparse (void);

#endif /* !YY_FRONTEND_VERILOG_YY_VERILOG_PARSER_TAB_HH_INCLUDED  */
