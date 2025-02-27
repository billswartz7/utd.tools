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

#ifndef YY_VL_PARSE_H_INCLUDED
# define YY_VL_PARSE_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int VLdebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IDENTIFIER = 258,
    SYSTEM_IDENTIFIER = 259,
    STRING = 260,
    TIME_LITERAL = 261,
    TYPE_IDENTIFIER = 262,
    PACKAGE_IDENTIFIER = 263,
    DISCIPLINE_IDENTIFIER = 264,
    PATHPULSE_IDENTIFIER = 265,
    BASED_NUMBER = 266,
    DEC_NUMBER = 267,
    UNBASED_NUMBER = 268,
    REALTIME = 269,
    K_PLUS_EQ = 270,
    K_MINUS_EQ = 271,
    K_INCR = 272,
    K_DECR = 273,
    K_LE = 274,
    K_GE = 275,
    K_EG = 276,
    K_EQ = 277,
    K_NE = 278,
    K_CEQ = 279,
    K_CNE = 280,
    K_WEQ = 281,
    K_WNE = 282,
    K_LP = 283,
    K_LS = 284,
    K_RS = 285,
    K_RSS = 286,
    K_SG = 287,
    K_CONTRIBUTE = 288,
    K_PO_POS = 289,
    K_PO_NEG = 290,
    K_POW = 291,
    K_PSTAR = 292,
    K_STARP = 293,
    K_DOTSTAR = 294,
    K_LOR = 295,
    K_LAND = 296,
    K_NAND = 297,
    K_NOR = 298,
    K_NXOR = 299,
    K_TRIGGER = 300,
    K_LEQUIV = 301,
    K_SCOPE_RES = 302,
    K_edge_descriptor = 303,
    K_always = 304,
    K_and = 305,
    K_assign = 306,
    K_begin = 307,
    K_buf = 308,
    K_bufif0 = 309,
    K_bufif1 = 310,
    K_case = 311,
    K_casex = 312,
    K_casez = 313,
    K_cmos = 314,
    K_deassign = 315,
    K_default = 316,
    K_defparam = 317,
    K_disable = 318,
    K_edge = 319,
    K_else = 320,
    K_end = 321,
    K_endcase = 322,
    K_endfunction = 323,
    K_endmodule = 324,
    K_endprimitive = 325,
    K_endspecify = 326,
    K_endtable = 327,
    K_endtask = 328,
    K_event = 329,
    K_for = 330,
    K_force = 331,
    K_forever = 332,
    K_fork = 333,
    K_function = 334,
    K_highz0 = 335,
    K_highz1 = 336,
    K_if = 337,
    K_ifnone = 338,
    K_initial = 339,
    K_inout = 340,
    K_input = 341,
    K_integer = 342,
    K_join = 343,
    K_large = 344,
    K_macromodule = 345,
    K_medium = 346,
    K_module = 347,
    K_nand = 348,
    K_negedge = 349,
    K_nmos = 350,
    K_nor = 351,
    K_not = 352,
    K_notif0 = 353,
    K_notif1 = 354,
    K_or = 355,
    K_output = 356,
    K_parameter = 357,
    K_pmos = 358,
    K_posedge = 359,
    K_primitive = 360,
    K_pull0 = 361,
    K_pull1 = 362,
    K_pulldown = 363,
    K_pullup = 364,
    K_rcmos = 365,
    K_real = 366,
    K_realtime = 367,
    K_reg = 368,
    K_release = 369,
    K_repeat = 370,
    K_rnmos = 371,
    K_rpmos = 372,
    K_rtran = 373,
    K_rtranif0 = 374,
    K_rtranif1 = 375,
    K_scalared = 376,
    K_small = 377,
    K_specify = 378,
    K_specparam = 379,
    K_strong0 = 380,
    K_strong1 = 381,
    K_supply0 = 382,
    K_supply1 = 383,
    K_table = 384,
    K_task = 385,
    K_time = 386,
    K_tran = 387,
    K_tranif0 = 388,
    K_tranif1 = 389,
    K_tri = 390,
    K_tri0 = 391,
    K_tri1 = 392,
    K_triand = 393,
    K_trior = 394,
    K_trireg = 395,
    K_vectored = 396,
    K_wait = 397,
    K_wand = 398,
    K_weak0 = 399,
    K_weak1 = 400,
    K_while = 401,
    K_wire = 402,
    K_wor = 403,
    K_xnor = 404,
    K_xor = 405,
    K_Shold = 406,
    K_Snochange = 407,
    K_Speriod = 408,
    K_Srecovery = 409,
    K_Ssetup = 410,
    K_Ssetuphold = 411,
    K_Sskew = 412,
    K_Swidth = 413,
    KK_attribute = 414,
    K_bool = 415,
    K_logic = 416,
    K_automatic = 417,
    K_endgenerate = 418,
    K_generate = 419,
    K_genvar = 420,
    K_localparam = 421,
    K_noshowcancelled = 422,
    K_pulsestyle_onevent = 423,
    K_pulsestyle_ondetect = 424,
    K_showcancelled = 425,
    K_signed = 426,
    K_unsigned = 427,
    K_Sfullskew = 428,
    K_Srecrem = 429,
    K_Sremoval = 430,
    K_Stimeskew = 431,
    K_cell = 432,
    K_config = 433,
    K_design = 434,
    K_endconfig = 435,
    K_incdir = 436,
    K_include = 437,
    K_instance = 438,
    K_liblist = 439,
    K_library = 440,
    K_use = 441,
    K_wone = 442,
    K_uwire = 443,
    K_alias = 444,
    K_always_comb = 445,
    K_always_ff = 446,
    K_always_latch = 447,
    K_assert = 448,
    K_assume = 449,
    K_before = 450,
    K_bind = 451,
    K_bins = 452,
    K_binsof = 453,
    K_bit = 454,
    K_break = 455,
    K_byte = 456,
    K_chandle = 457,
    K_class = 458,
    K_clocking = 459,
    K_const = 460,
    K_constraint = 461,
    K_context = 462,
    K_continue = 463,
    K_cover = 464,
    K_covergroup = 465,
    K_coverpoint = 466,
    K_cross = 467,
    K_dist = 468,
    K_do = 469,
    K_endclass = 470,
    K_endclocking = 471,
    K_endgroup = 472,
    K_endinterface = 473,
    K_endpackage = 474,
    K_endprogram = 475,
    K_endproperty = 476,
    K_endsequence = 477,
    K_enum = 478,
    K_expect = 479,
    K_export = 480,
    K_extends = 481,
    K_extern = 482,
    K_final = 483,
    K_first_match = 484,
    K_foreach = 485,
    K_forkjoin = 486,
    K_iff = 487,
    K_ignore_bins = 488,
    K_illegal_bins = 489,
    K_import = 490,
    K_inside = 491,
    K_int = 492,
    K_interface = 493,
    K_intersect = 494,
    K_join_any = 495,
    K_join_none = 496,
    K_local = 497,
    K_longint = 498,
    K_matches = 499,
    K_modport = 500,
    K_new = 501,
    K_null = 502,
    K_package = 503,
    K_packed = 504,
    K_priority = 505,
    K_program = 506,
    K_property = 507,
    K_protected = 508,
    K_pure = 509,
    K_rand = 510,
    K_randc = 511,
    K_randcase = 512,
    K_randsequence = 513,
    K_ref = 514,
    K_return = 515,
    K_sequence = 516,
    K_shortint = 517,
    K_shortreal = 518,
    K_solve = 519,
    K_static = 520,
    K_string = 521,
    K_struct = 522,
    K_super = 523,
    K_tagged = 524,
    K_this = 525,
    K_throughout = 526,
    K_timeprecision = 527,
    K_timeunit = 528,
    K_type = 529,
    K_typedef = 530,
    K_union = 531,
    K_unique = 532,
    K_var = 533,
    K_virtual = 534,
    K_void = 535,
    K_wait_order = 536,
    K_wildcard = 537,
    K_with = 538,
    K_within = 539,
    K_accept_on = 540,
    K_checker = 541,
    K_endchecker = 542,
    K_eventually = 543,
    K_global = 544,
    K_implies = 545,
    K_let = 546,
    K_nexttime = 547,
    K_reject_on = 548,
    K_restrict = 549,
    K_s_always = 550,
    K_s_eventually = 551,
    K_s_nexttime = 552,
    K_s_until = 553,
    K_s_until_with = 554,
    K_strong = 555,
    K_sync_accept_on = 556,
    K_sync_reject_on = 557,
    K_unique0 = 558,
    K_until = 559,
    K_until_with = 560,
    K_untyped = 561,
    K_weak = 562,
    K_implements = 563,
    K_interconnect = 564,
    K_nettype = 565,
    K_soft = 566,
    K_above = 567,
    K_abs = 568,
    K_absdelay = 569,
    K_abstol = 570,
    K_access = 571,
    K_acos = 572,
    K_acosh = 573,
    K_ac_stim = 574,
    K_aliasparam = 575,
    K_analog = 576,
    K_analysis = 577,
    K_asin = 578,
    K_asinh = 579,
    K_atan = 580,
    K_atan2 = 581,
    K_atanh = 582,
    K_branch = 583,
    K_ceil = 584,
    K_connect = 585,
    K_connectmodule = 586,
    K_connectrules = 587,
    K_continuous = 588,
    K_cos = 589,
    K_cosh = 590,
    K_ddt = 591,
    K_ddt_nature = 592,
    K_ddx = 593,
    K_discipline = 594,
    K_discrete = 595,
    K_domain = 596,
    K_driver_update = 597,
    K_endconnectrules = 598,
    K_enddiscipline = 599,
    K_endnature = 600,
    K_endparamset = 601,
    K_exclude = 602,
    K_exp = 603,
    K_final_step = 604,
    K_flicker_noise = 605,
    K_floor = 606,
    K_flow = 607,
    K_from = 608,
    K_ground = 609,
    K_hypot = 610,
    K_idt = 611,
    K_idtmod = 612,
    K_idt_nature = 613,
    K_inf = 614,
    K_initial_step = 615,
    K_laplace_nd = 616,
    K_laplace_np = 617,
    K_laplace_zd = 618,
    K_laplace_zp = 619,
    K_last_crossing = 620,
    K_limexp = 621,
    K_ln = 622,
    K_log = 623,
    K_max = 624,
    K_merged = 625,
    K_min = 626,
    K_nature = 627,
    K_net_resolution = 628,
    K_noise_table = 629,
    K_paramset = 630,
    K_potential = 631,
    K_pow = 632,
    K_resolveto = 633,
    K_sin = 634,
    K_sinh = 635,
    K_slew = 636,
    K_split = 637,
    K_sqrt = 638,
    K_tan = 639,
    K_tanh = 640,
    K_timer = 641,
    K_transition = 642,
    K_units = 643,
    K_white_noise = 644,
    K_wreal = 645,
    K_zi_nd = 646,
    K_zi_np = 647,
    K_zi_zd = 648,
    K_zi_zp = 649,
    K_TAND = 650,
    K_MUL_EQ = 651,
    K_DIV_EQ = 652,
    K_MOD_EQ = 653,
    K_AND_EQ = 654,
    K_OR_EQ = 655,
    K_XOR_EQ = 656,
    K_LS_EQ = 657,
    K_RS_EQ = 658,
    K_RSS_EQ = 659,
    UNARY_PREC = 660,
    less_than_K_else = 661,
    no_timeunits_declaration = 662,
    one_timeunits_declaration = 663
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 364 "parse.y" /* yacc.c:1916  */

      bool flag;

      char letter;
      int  int_val;

	/* text items are C strings allocated by the lexor using
	   strdup. They can be put into lists with the texts type. */
      char*text;
      list<perm_string>*perm_strings;

      list<pform_port_t>*port_list;

      vector<pform_tf_port_t>* tf_ports;

      pform_name_t*pform_name;

      ivl_discipline_t discipline;

      hname_t*hier;

      list<string>*strings;

      struct str_pair_t drive;

      PCase::Item*citem;
      svector<PCase::Item*>*citems;

      lgate*gate;
      svector<lgate>*gates;

      Module::port_t *mport;
      LexicalScope::range_t* value_range;
      vector<Module::port_t*>*mports;

      named_number_t* named_number;
      list<named_number_t>* named_numbers;

      named_pexpr_t*named_pexpr;
      list<named_pexpr_t>*named_pexprs;
      struct parmvalue_t*parmvalue;
      list<pform_range_t>*ranges;

      PExpr*expr;
      list<PExpr*>*exprs;

      svector<PEEvent*>*event_expr;

      ivl_case_quality_t case_quality;
      NetNet::Type nettype;
      PGBuiltin::Type gatetype;
      NetNet::PortType porttype;
      ivl_variable_type_t vartype;
      PBlock::BL_TYPE join_keyword;

      PWire*wire;
      vector<PWire*>*wires;

      PEventStatement*event_statement;
      Statement*statement;
      vector<Statement*>*statement_list;

      net_decl_assign_t*net_decl_assign;
      enum_type_t*enum_type;

      decl_assignment_t*decl_assignment;
      list<decl_assignment_t*>*decl_assignments;

      struct_member_t*struct_member;
      list<struct_member_t*>*struct_members;
      struct_type_t*struct_type;

      data_type_t*data_type;
      class_type_t*class_type;
      real_type_t::type_t real_type;
      property_qualifier_t property_qualifier;
      PPackage*package;

      struct {
	    char*text;
	    data_type_t*type;
      } type_identifier;

      struct {
	    data_type_t*type;
	    list<PExpr*>*exprs;
      } class_declaration_extends;

      struct {
	    char*text;
	    PExpr*expr;
      } genvar_iter;

      verinum* number;

      verireal* realtime;

      PSpecPath* specpath;
      list<index_component_t> *dimensions;

      LexicalScope::lifetime_t lifetime;

#line 566 "parse.h" /* yacc.c:1916  */
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


extern YYSTYPE VLlval;
extern YYLTYPE VLlloc;
int VLparse (void);

#endif /* !YY_VL_PARSE_H_INCLUDED  */
