/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IN_P = 258,
     IS_P = 259,
     OR_P = 260,
     AND_P = 261,
     NOT_P = 262,
     NULL_P = 263,
     TRUE_P = 264,
     ARRAY_T = 265,
     FALSE_P = 266,
     NUMERIC_T = 267,
     OBJECT_T = 268,
     STRING_T = 269,
     BOOLEAN_T = 270,
     STRING_P = 271,
     NUMERIC_P = 272
   };
#endif
/* Tokens.  */
#define IN_P 258
#define IS_P 259
#define OR_P 260
#define AND_P 261
#define NOT_P 262
#define NULL_P 263
#define TRUE_P 264
#define ARRAY_T 265
#define FALSE_P 266
#define NUMERIC_T 267
#define OBJECT_T 268
#define STRING_T 269
#define BOOLEAN_T 270
#define STRING_P 271
#define NUMERIC_P 272




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 135 "fhirpath_gram.y"
{
	string 				str;
	List				*elems; /* list of FhirpathParseItem */

	FhirpathParseItem	*value;
}
/* Line 1529 of yacc.c.  */
#line 90 "fhirpath_gram.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



