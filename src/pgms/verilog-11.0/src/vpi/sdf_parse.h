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

#ifndef YY_SDF_SDF_PARSE_H_INCLUDED
# define YY_SDF_SDF_PARSE_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int sdfdebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    K_ABSOLUTE = 258,
    K_CELL = 259,
    K_CELLTYPE = 260,
    K_COND = 261,
    K_CONDELSE = 262,
    K_DATE = 263,
    K_DELAYFILE = 264,
    K_DELAY = 265,
    K_DESIGN = 266,
    K_DIVIDER = 267,
    K_HOLD = 268,
    K_INCREMENT = 269,
    K_INSTANCE = 270,
    K_INTERCONNECT = 271,
    K_IOPATH = 272,
    K_NEGEDGE = 273,
    K_PATHPULSE = 274,
    K_PATHPULSEPERCENT = 275,
    K_PERIOD = 276,
    K_POSEDGE = 277,
    K_PROCESS = 278,
    K_PROGRAM = 279,
    K_RECREM = 280,
    K_RECOVERY = 281,
    K_REMOVAL = 282,
    K_SDFVERSION = 283,
    K_SETUP = 284,
    K_SETUPHOLD = 285,
    K_TEMPERATURE = 286,
    K_TIMESCALE = 287,
    K_TIMINGCHECK = 288,
    K_VENDOR = 289,
    K_VERSION = 290,
    K_VOLTAGE = 291,
    K_WIDTH = 292,
    K_01 = 293,
    K_10 = 294,
    K_0Z = 295,
    K_Z1 = 296,
    K_1Z = 297,
    K_Z0 = 298,
    K_EQ = 299,
    K_NE = 300,
    K_CEQ = 301,
    K_CNE = 302,
    K_LOGICAL_ONE = 303,
    K_LOGICAL_ZERO = 304,
    K_LAND = 305,
    K_LOR = 306,
    HCHAR = 307,
    QSTRING = 308,
    IDENTIFIER = 309,
    REAL_NUMBER = 310,
    INTEGER = 311
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 39 "sdf_parse.y" /* yacc.c:1916  */

      unsigned long int_val;
      double real_val;
      char*  string_val;

      struct sdf_delay_s delay;
      struct port_with_edge_s port_with_edge;
      struct sdf_delval_list_s delval_list;

#line 121 "../sdf_parse.h" /* yacc.c:1916  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE sdflval;
extern YYLTYPE sdflloc;
int sdfparse (void);

#endif /* !YY_SDF_SDF_PARSE_H_INCLUDED  */
