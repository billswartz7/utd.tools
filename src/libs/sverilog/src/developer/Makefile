LEX=flex -v -d -P sverilog_ -o lex.yy.c
LEX=flex -v -P sverilog_ -o lex.yy.c
YACC=bison -p sverilog_
UTDBYACC=${UTDTOOLS}/../${UTDTOOLSVERSION}/bin/${UTDTOOLSOS}/utdbyacc
YACC=${UTDBYACC} -c -b sverilog -p sverilog_
RM=rm -f
MV=mv
GREP=grep

all: ../sverilog_parser.c ../sverilog_scanner.c

../sverilog_parser.c : sverilog.y
	$(YACC) -v -d sverilog.y
	$(MV) sverilog.tab.c tmp
	$(GREP) -v "# line" tmp | $(GREP) -v "#line" > sverilog.tab.c
	$(MV) sverilog.tab.c ../sverilog_parser.c
	$(MV) sverilog.tab.h tmp
	$(GREP) -v "# line" tmp | $(GREP) -v "#line" > sverilog.tab.h
	$(MV) sverilog.tab.h ../sverilog.tab.h

../sverilog_scanner.c : sverilog.l
	$(LEX) sverilog.l
	$(MV) lex.yy.c tmp
	$(GREP) -v "# line" tmp | $(GREP) -v "#line" > lex.yy.c
	$(MV) lex.yy.c ../sverilog_scanner.c

clean:	
	$(RM) *.tab.c *~ *.output tmp


distclean : clean	
	$(RM) ../sverilog_parser.c ../sverilog.tab.h ../sverilog_scanner.c

:

