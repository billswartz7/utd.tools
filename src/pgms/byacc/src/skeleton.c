#include "defs.h"

/*  The banner used here should be replaced with an #ident directive	*/
/*  if the target C compiler supports #ident directives.		*/
/*									*/
/*  If the skeleton is changed, the banner should be changed so that	*/
/*  the altered version can easily be distinguished from the original.	*/

char *bannerG[] =
{
    "#ifndef lint",
    "static char yysccsid[] = \"@(#)yaccpar  1.9 (TimberWolf version derived from Berkeley) 08/25/94\";",
    "#endif",
    "#define YYBYACC 1",
    0
};


char *global_varsG[] = 
{
    "parse",
    "lex",
    "error",
    "debug",
    "nerrs",
    "errflag",
    "lval",
    0
} ;

char *tablesG[] =
{
    "static short yylhs[];",
    "static short yylen[];",
    "static short yydefred[];",
    "static short yydgoto[];",
    "static short yysindex[];",
    "static short yyrindex[];",
    "static short yygindex[];",
    "static short yytable[];",
    "static short yycheck[];",
    "#if YYDEBUG",
    "static char *yyname[];",
    "static char *yyrule[];",
    "#endif",
    0
};


char *header1G[] =
{
    "#define yyclearin (yychar=(-1))",
    "#define yyerrok (yyerrflag=0)",
    "#ifdef YYSTACKSIZE",
    "#ifndef YYMAXDEPTH",
    "#define YYMAXDEPTH YYSTACKSIZE",
    "#endif",
    "#else",
    "#ifdef YYMAXDEPTH",
    "#define YYSTACKSIZE YYMAXDEPTH",
    "#else",
    "#define YYSTACKSIZE 500",
    "#define YYMAXDEPTH 500",
    "#endif",
    "#endif",
    "static int yycnprs = 0;",
    "int yydebug;",
    "int yynerrs;",
    "int yyerrflag;",
    "static int yychar;",
    "static short *yyssp;",
    "static YYSTYPE *yyvsp;",
    "static YYSTYPE yyval;",
    "YYSTYPE yylval;",
    "static short yyss[YYSTACKSIZE];",
    "static YYSTYPE yyvs[YYSTACKSIZE];",
    "#define yystacksize YYSTACKSIZE",
    0
};

char *header2G[] =
{
    "#ifdef YYITOOLS",
    "extern int yyparse(YLEXPTR ylex_p);",
    "extern void yyerror(YLEXPTR ylex_p,char *s);",
    "#endif /* YYITOOLS */",
    "#ifdef YYCLIENTDATA",
    "extern int yyparse(VOIDPTR clientData);",
    "extern void yyerror(VOIDPTR clientData,char *s);",
    "#endif /* YYCLIENTDATA */",
    0
};

char *header2_altG = "extern int yyparse( %s ) ;\n" ;
char *header2b_altG = "extern void yyerror( %s, const char *s);\n" ;


char *body1G[] =
{
    "#define YYABORT goto yyabort",
    "#define YYACCEPT goto yyaccept",
    "#define YYERROR goto yyerrlab",
    "int",
    0
} ;

char *body2G[] =
{
    "#ifdef YYITOOLS",
    "yyparse(YLEXPTR ylex_p)",
    "#else /* YYITOOLS */",
    "#ifdef YYCLIENTDATA",
    "yyparse(void *clientData)",
    "#else /* !YYCLIENTDATA */",
    "yyparse(void)",
    "#endif /* YYCLIENTDATA */",
    "#endif /* YYITOOLS */",
    0
} ;

char *body2_altG = "yyparse( %s )\n" ;

char *body3G[] =
{
    "{",
    "    register int yym, yyn, yystate;",
    "#if YYDEBUG",
    "    register char *yys;",
    "",
    "",
    "#ifdef YYITOOLS",
    "    if( (yys = Ygetenv(\"YYDEBUG\")))",
    "#else /* YYITOOLS */",
    "    if( (yys = getenv(\"YYDEBUG\")))",
    "#endif /* YYITOOLS */",
    "    {",
    "        yyn = *yys;",
    "        if (yyn >= '0' && yyn <= '9')",
    "            yydebug = yyn - '0';",
    "    }",
    "#endif",
    "",
    "    yynerrs = 0;",
    "    yyerrflag = 0;",
    "    yychar = (-1);",
    "",
    "    yyssp = yyss;",
    "    yyvsp = yyvs;",
    "    *yyssp = yystate = 0;",
    "",
    "yyloop:",
    "    if( (yyn = yydefred[yystate]) ) goto yyreduce;",
    "    if (yychar < 0)",
    "    {",
    0
} ;

char *body4G[] =
{
    "#ifdef YYITOOLS",
    "        if ((yychar = Ylex_yylex(ylex_p)) < 0) yychar = 0;",
    "#else /* YYITOOLS */",
    "#ifdef YYLEXCLIENTDATA",
    "        if ((yychar = yylex(clientData)) < 0) yychar = 0;",
    "#else /* !YYLEXCLIENTDATA */",
    "        if ((yychar = yylex()) < 0) yychar = 0;",
    "#endif /* YYLEXCLIENTDATA */",
    "#endif /* YYITOOLS */",
    0
} ;

char *body4_altG = "        if ((yychar = yylex( %s )) < 0) yychar = 0;\n" ;

char *body5G[] =
{
    "#if YYDEBUG",
    "        if (yydebug)",
    "        {",
    "            yys = 0;",
    "            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];",
    "            if (!yys) yys = \"illegal-symbol\";",
    "            printf(\"yydebug: state %d, reading %d (%s)\\n\", yystate,",
    "                    yychar, yys);",
    "        }",
    "#endif",
    "    }",
    "    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&",
    "            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)",
    "    {",
    "#if YYDEBUG",
    "        if (yydebug)",
    "            printf(\"yydebug: state %d, shifting to state %d\\n\",",
    "                    yystate, yytable[yyn]);",
    "#endif",
    "        if (yyssp >= yyss + yystacksize - 1)",
    "        {",
    "            goto yyoverflow;",
    "        }",
    "        *++yyssp = yystate = yytable[yyn];",
    "        *++yyvsp = yylval;",
    "        yychar = (-1);",
    "        if (yyerrflag > 0)  --yyerrflag;",
    "        goto yyloop;",
    "    }",
    "    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&",
    "            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)",
    "    {",
    "        yyn = yytable[yyn];",
    "        goto yyreduce;",
    "    }",
    "    if (yyerrflag) goto yyinrecovery;",
    "#ifdef lint",
    "    goto yynewerror;",
    "#endif",
    "yynewerror:",
    "    {",
    "        int test_state, i, expect, two_or_more, blen ;",
    "        char err_msg[BUFSIZ] ;",
    "        if( yyname[yychar] ){",
    "            sprintf( err_msg, \"Found %s.\\nExpected \",",
    "                yyname[yychar] ) ;",
    "        } else {",
    "            sprintf( err_msg, \"Found unknown token.\\nExpected \");",
    "        }",
    "        two_or_more = 0 ;",
    "        blen = strlen(err_msg) ;",
    "        if( (test_state = yysindex[yystate]) ){",
    "          for( i = 1; i <= YYMAXTOKEN; i++ ){",
    "            expect = test_state + i ;",
    "            if((expect <= YYTABLESIZE) &&",
    "               (yycheck[expect] == i) &&",
    "               yyname[i]){",
    "              if( two_or_more ){",
    "                if( blen < BUFSIZ ){",
    "                  strcat( err_msg, \" | \" ) ;",
    "                }",
    "                blen += 3 ;",
    "              } else {",
    "                two_or_more = 1 ;",
    "              }",
    "              blen += strlen(yyname[i]) ;",
    "              if( blen < BUFSIZ ){",
    "                strcat( err_msg, yyname[i] ) ;",
    "              }",
    "            }",
    "          }",
    "        }",
    "        if( (test_state = yyrindex[yystate]) ){",
    "          for( i = 1; i <= YYMAXTOKEN; i++ ){",
    "            expect = test_state + i ;",
    "            if((expect <= YYTABLESIZE) &&",
    "               (yycheck[expect] == i) &&",
    "               yyname[i]){",
    "              if( two_or_more ){",
    "                if( blen < BUFSIZ ){",
    "                  strcat( err_msg, \" | \" ) ;",
    "                }",
    "                blen += 3 ;",
    "              } else {",
    "                two_or_more = 1 ;",
    "              }",
    "              blen += strlen(yyname[i]) ;",
    "              if( blen < BUFSIZ ){",
    "                strcat( err_msg, yyname[i] ) ;",
    "              }",
    "            }",
    "          }",
    "        }",
    0
};


char *body6G[] =
{
    "#ifdef YYITOOLS",
    "        yyerror( ylex_p, err_msg ) ;",
    "#else /* ! YYITOOLS */",
    "#ifdef YYCLIENTDATA",
    "        yyerror( clientData, err_msg ) ;",
    "#else /* ! YYCLIENTDATA */",
    "        yyerror( err_msg ) ;",
    "#endif /* YYCLIENTDATA */",
    "#endif /* YYITOOLS */",
    0
};

char *body6_altG = "        yyerror( %s, err_msg ) ;\n" ;

char *body7G[] =
{
    "        if (yycnprs) {",
    "          yychar = (-1);",
    "          if (yyerrflag > 0)  --yyerrflag;",
    "          goto yyloop;",
    "        }",
    "    }",
    "#ifdef lint",
    "    goto yyerrlab;",
    "#endif",
    "yyerrlab:",
    "    ++yynerrs;",
    "yyinrecovery:",
    "    if (yyerrflag < 3)",
    "    {",
    "        yyerrflag = 3;",
    "        for (;;)",
    "        {",
    "            if ((yyn = yysindex[*yyssp]) && (yyn += YYERRCODE) >= 0 &&",
    "                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)",
    "            {",
    "#if YYDEBUG",
    "                if (yydebug)",
    "                    printf(\"yydebug: state %d, error recovery shifting\\",
    " to state %d\\n\", *yyssp, yytable[yyn]);",
    "#endif",
    "                if (yyssp >= yyss + yystacksize - 1)",
    "                {",
    "                    goto yyoverflow;",
    "                }",
    "                *++yyssp = yystate = yytable[yyn];",
    "                *++yyvsp = yylval;",
    "                goto yyloop;",
    "            }",
    "            else",
    "            {",
    "#if YYDEBUG",
    "                if (yydebug)",
    "                    printf(\"yydebug: error recovery discarding state %d\
\\n\",",
    "                            *yyssp);",
    "#endif",
    "                if (yyssp <= yyss) goto yyabort;",
    "                --yyssp;",
    "                --yyvsp;",
    "            }",
    "        }",
    "    }",
    "    else",
    "    {",
    "        if (yychar == 0) goto yyabort;",
    "#if YYDEBUG",
    "        if (yydebug)",
    "        {",
    "            yys = 0;",
    "            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];",
    "            if (!yys) yys = \"illegal-symbol\";",
    "            printf(\"yydebug: state %d, error recovery discards token %d\
 (%s)\\n\",",
    "                    yystate, yychar, yys);",
    "        }",
    "#endif",
    "        yychar = (-1);",
    "        goto yyloop;",
    "    }",
    "yyreduce:",
    "#if YYDEBUG",
    "    if (yydebug)",
    "        printf(\"yydebug: state %d, reducing by rule %d (%s)\\n\",",
    "                yystate, yyn, yyrule[yyn]);",
    "#endif",
    "    yym = yylen[yyn];",
    "    yyval = yyvsp[1-yym];",
    "    switch (yyn)",
    "    {",
    0
};


char *trailer1G[] =
{
    "    }",
    "    yyssp -= yym;",
    "    yystate = *yyssp;",
    "    yyvsp -= yym;",
    "    yym = yylhs[yyn];",
    "    if (yystate == 0 && yym == 0)",
    "    {",
    "#if YYDEBUG",
    "        if (yydebug)",
    "            printf(\"yydebug: after reduction, shifting from state 0 to\\",
    " state %d\\n\", YYFINAL);",
    "#endif",
    "        yystate = YYFINAL;",
    "        *++yyssp = YYFINAL;",
    "        *++yyvsp = yyval;",
    "        if (yychar < 0)",
    "        {",
    0
};

char *trailer2G[] =
{
    "#ifdef YYITOOLS",
    "            if ((yychar = Ylex_yylex(ylex_p)) < 0) yychar = 0;",
    "#else /* YYITOOLS */",
    "#ifdef YYLEXCLIENTDATA",
    "        if ((yychar = yylex(clientData)) < 0) yychar = 0;",
    "#else /* !YYLEXCLIENTDATA */",
    "            if ((yychar = yylex()) < 0) yychar = 0;",
    "#endif /* YYLEXCLIENTDATA */",
    "#endif /* YYITOOLS */",
    0
};

char *trailer2_altG = "        if ((yychar = yylex( %s )) < 0) yychar = 0;\n" ;

char *trailer3G[] =
{
    "#if YYDEBUG",
    "            if (yydebug)",
    "            {",
    "                yys = 0;",
    "                if (yychar <= YYMAXTOKEN) yys = yyname[yychar];",
    "                if (!yys) yys = \"illegal-symbol\";",
    "                printf(\"yydebug: state %d, reading %d (%s)\\n\",",
    "                        YYFINAL, yychar, yys);",
    "            }",
    "#endif",
    "        }",
    "        if (yychar == 0) goto yyaccept;",
    "        goto yyloop;",
    "    }",
    "    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&",
    "            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)",
    "        yystate = yytable[yyn];",
    "    else",
    "        yystate = yydgoto[yym];",
    "#if YYDEBUG",
    "    if (yydebug)",
    "        printf(\"yydebug: after reduction, shifting from state %d \\",
    "to state %d\\n\", *yyssp, yystate);",
    "#endif",
    "    if (yyssp >= yyss + yystacksize - 1)",
    "    {",
    "        goto yyoverflow;",
    "    }",
    "    *++yyssp = yystate;",
    "    *++yyvsp = yyval;",
    "    goto yyloop;",
    "yyoverflow:",
    0
};


char *trailer4G[] =
{
    "#ifdef YYITOOLS",
    "    yyerror( ylex_p, \"yacc stack overflow\");",
    "#else /* ! YYITOOLS */",
    "#ifdef YYCLIENTDATA",
    "    yyerror( clientData, \"yacc stack overflow\");",
    "#else /* ! YYCLIENTDATA */",
    "    yyerror(\"yacc stack overflow\");",
    "#endif /* YYCLIENTDATA */",
    "#endif /* YYITOOLS */",
    0
};

char *trailer4_altG = "    yyerror( %s, \"yacc stack overflow\");\n" ;

char *trailer5G[] =
{
    "yyabort:",
    "    return (1);",
    "yyaccept:",
    "    return (0);",
    "}",
    0
};


void write_section(char *section[])
{
    register int i;
    register FILE *fp;

    fp = code_file;
    for (i = 0; section[i]; ++i)
    {
	++outline;
	fprintf(fp, "%s\n", section[i]);
    }
}
