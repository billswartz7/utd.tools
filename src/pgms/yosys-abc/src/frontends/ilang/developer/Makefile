BISON = bison

all: ../ilang_parser.tab.cc ../ilang_lexer.cc

../ilang_parser.tab.cc: ilang_parser.y
	$(BISON) -o $@ -d -r all -b frontends/ilang/ilang_parser $<

../ilang_parser.tab.hh: ../ilang_parser.tab.cc

../ilang_lexer.cc: ilang_lexer.l
	flex -o ../ilang_lexer.cc $<
