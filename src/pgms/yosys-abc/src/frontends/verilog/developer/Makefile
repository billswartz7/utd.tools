BISON = bison

all: ../verilog_parser.tab.cc ../verilog_lexer.cc

../verilog_lexer.cc: verilog_lexer.l

../verilog_parser.tab.cc: verilog_parser.y
	$(BISON) -o $@ -d -r all -b frontends/verilog/verilog_parser $<

../verilog_parser.tab.hh: verilog_parser.tab.cc

../verilog_lexer.cc: verilog_lexer.l
	flex -o ../verilog_lexer.cc $<

clean:
	rm -f ../verilog_lexer.cc ../verilog_parser.tab.cc
	rm -f ../verilog_parser.tab.hh
	rm -f ../verilog_parser.output
