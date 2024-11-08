/*
 *  Physical yosys -- Brown University
 *
 *  Copyright (C) 2019  Brown University
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *  By: Soheil Hashemi 2019
 *  soheil_hashemi@brown.edu
 *
 */

// [[CITE]] ABC
// Berkeley Logic Synthesis and Verification Group, ABC: A System for Sequential Synthesis and Verification
// http://www.eecs.berkeley.edu/~alanmi/abc/

// [[CITE]] Berkeley Logic Interchange Format (BLIF)
// University of California. Berkeley. July 28, 1992
// http://www.ece.cmu.edu/~ee760/760docs/blif.pdf

// [[CITE]] Kahn's Topological sorting algorithm
// Kahn, Arthur B. (1962), "Topological sorting of large networks", Communications of the ACM 5 (11): 558-562, doi:10.1145/368996.369025
// http://en.wikipedia.org/wiki/Topological_sorting

#define ABC_DXBXUX "dnsize -x;buffer -p -x;upsize -x;"
#define ABC_DBU "dnsize;buffer -p;upsize;"

#include "kernel/register.h"
#include "kernel/sigtools.h"
#include "kernel/celltypes.h"
#include "kernel/log.h"
#include <stdlib.h>
#include <stdio.h>
#include <cerrno>
#include <sstream>
#include <climits>
#include <string>
#include <set>
#include <map>
#include <vector>
#include <sys/stat.h>

#ifndef _WIN32
#  include <unistd.h>
#  include <dirent.h>
#endif

#include "passes/techmap/libparse.h"
#include "frontends/blif/blifparse.h"

#ifdef YOSYS_LINK_ABC
extern "C" int Abc_RealMain(int argc, char *argv[]);
#endif

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

struct wire_t
{
	int id;
	bool is_reg_in, is_reg_out;
	bool is_PI, is_PO;
	bool is_port;
    bool is_comb;
	RTLIL::SigBit bit;
	RTLIL::State init;
};

bool markgroups;
int map_autoidx;
SigMap assign_map;
RTLIL::Module *module;
std::vector<wire_t> signal_list;
std::map<RTLIL::SigBit, int> signal_map;
std::map<RTLIL::SigBit, RTLIL::State> signal_init;
bool recover_init;
vector<shared_str> cstr_buf;
dict<IdString, double> cell_area;

bool clk_polarity, en_polarity;
RTLIL::SigSpec clk_sig, en_sig;
dict<int, std::string> pi_map, po_map;
dict<std::string, int> name_map;
int extra_wires_count = 0;
bool is_DFF (RTLIL::Cell* cell)
{
    return (cell->hasPort("\\D") && (cell->hasPort("\\Q") || cell->hasPort("\\QN")));
}

std::string id(RTLIL::IdString internal_id)
{
    const char *str = internal_id.c_str();
    bool do_escape = false;

    if (*str == '\\')
        str++;

    if ('0' <= *str && *str <= '9')
        do_escape = true;

    for (int i = 0; str[i]; i++)
    {
        if ('0' <= str[i] && str[i] <= '9')
            continue;
        if ('a' <= str[i] && str[i] <= 'z')
            continue;
        if ('A' <= str[i] && str[i] <= 'Z')
            continue;
        if (str[i] == '_')
            continue;
        do_escape = true;
        break;
    }

    if (do_escape)
        return "\\" + std::string(str) + " ";
    return std::string(str);
}

void read_liberty_cellarea(dict<IdString, double> &cell_area, string liberty_file)
{
	std::ifstream f;
	f.open(liberty_file.c_str());
	yosys_input_files.insert(liberty_file);
	if (f.fail())
		log_cmd_error("Can't open liberty file `%s': %s\n", liberty_file.c_str(), strerror(errno));
	LibertyParser libparser(f);
	f.close();

	for (auto cell : libparser.ast->children)
	{
		if (cell->id != "cell" || cell->args.size() != 1)
			continue;

		LibertyAst *ar = cell->find("area");
		if (ar != NULL && !ar->value.empty())
			cell_area["\\" + cell->args[0]] = atof(ar->value.c_str());
	}
}

void RunInnovus(std::string innovus_script, std::string tempdir_name, std::string outSpefFilePath)
{
    std::ifstream inScript(innovus_script);
    std::string modScriptPath = tempdir_name + "/mod_innovus_script.tcl";
    std::ofstream mod_inScript(modScriptPath);

    mod_inScript << "set init_verilog \"" << tempdir_name << "/netlist.v\"\n";
    mod_inScript << inScript.rdbuf();
    mod_inScript << "rcOut -rc_corner Cmax -spef " << outSpefFilePath << "\n\nexit\n";
    mod_inScript.close();
    inScript.close();

    std::string pInnovusCommand = stringf("innovus -batch -no_gui -files %s",modScriptPath.c_str());
    if (system(pInnovusCommand.c_str()) == -1)
    {
        log_cmd_error("Failed to Run Innovus.\n");
        log_abort();
    }
}

void RunFloorPlanner(std::string tempdir_name, std::string ntkName, double module_area)
{
    log("Running FloorPlanner.\n");
    std::stringstream pFPCommand;
    pFPCommand << "python abc/tools/pyFP.py " << tempdir_name << " " << ntkName << " " << module_area;
    if (system(pFPCommand.str().c_str()) == -1)
    {
        log_cmd_error("Failed to Run FloorPlanner in \"%s\".\n",pFPCommand.str().c_str());
        log_abort();
    }
}

void RunReplace(std::string tempdir_name, std::string ntkName, std::string outSpefFilePath)
{
    log("Running Replace.\n");

    std::string pDir = "abc/tools/RePlAce/" + ntkName;
    mkdir(pDir.c_str(), 0700);

    std::string pCopyCommand;
    pCopyCommand = "cp abc/tools/RePlAce/lefs/*.lef " + pDir;
    if (system(pCopyCommand.c_str()) == -1)
    {
        log_cmd_error("System call \"%s\" failed!\n",pCopyCommand.c_str());
        log_abort();
    }
    pCopyCommand = "cp " + tempdir_name + "/" + "netlist.v " + pDir + "/" + ntkName + "_gl.v";
    if (system(pCopyCommand.c_str()) == -1)
    {
        log_cmd_error("System call \"%s\" failed!\n",pCopyCommand.c_str());
        log_abort();
    }
    pCopyCommand = "cp " + tempdir_name + "/" + ntkName + ".def " + pDir;
    if (system(pCopyCommand.c_str()) == -1)
    {
        log_cmd_error("System call \"%s\" failed!\n",pCopyCommand.c_str());
        log_abort();
    }
    pCopyCommand = "rm -rf abc/tools/RePlAce/output/etc/" + ntkName;
    if (system(pCopyCommand.c_str()) == -1)
    {
        log_cmd_error("System call \"%s\" failed!\n",pCopyCommand.c_str());
        log_abort();
    }

    std::string pGRCommand;
    pGRCommand = "(cd abc/tools/RePlAce && python execute_lefdef.py " + ntkName + " -onlyGP -unitY 1080 -resPerMicron 16 -capPerMicron 0.048e-15 >/dev/null 2>&1)";
    if (system(pGRCommand.c_str()) == -1)
    {
        log_cmd_error("System call \"%s\" failed!\n",pGRCommand.c_str());
        log_abort();
    }

    // copy the spef output to abc/tools/spef_output/
    pCopyCommand = "cp abc/tools/RePlAce/output/etc/" + ntkName + "/experiment000/" + ntkName + "_gp.spef " + outSpefFilePath;
    if (system(pCopyCommand.c_str()) == -1)
    {
        log_cmd_error("System call \"%s\" failed!\n",pCopyCommand.c_str());
        log_abort();
    }

}
void FloorPlanandPlace(std::string tempdir_name, std::string innovus_script, std::string ntkName, double module_area)
{
    // Prepare for the SPEF out directory
    std::string pDir = "abc/tools/spef_output/";
    struct stat statbuf;
    if(stat(pDir.c_str(),&statbuf) != -1)
    {
        if (S_ISDIR(statbuf.st_mode)) {
            remove_directory(pDir);
        }
    }
    mkdir(pDir.c_str(), 0700);

    std::string outSpefFilePath = pDir + "netlist_gp.spef";
    if(innovus_script != "")
    {
        RunInnovus(innovus_script,tempdir_name,outSpefFilePath);
    }
    else
    {
        RunFloorPlanner(tempdir_name, ntkName, module_area);
        RunReplace(tempdir_name, ntkName, outSpefFilePath);
    }
}

const char *cstr(RTLIL::IdString id)
{
	std::string str = RTLIL::unescape_id(id);
	for (size_t i = 0; i < str.size(); i++)
		if (str[i] == '#' || str[i] == '=' || str[i] == '<' || str[i] == '>')
			str[i] = '?';
	cstr_buf.push_back(str);
	return cstr_buf.back().c_str();
}

const char *cstr(RTLIL::SigBit sig)
{
	if (sig.wire == NULL) {
		if (sig == RTLIL::State::S0) return "$false";
		if (sig == RTLIL::State::S1) return "$true";
		return "$undef";
	}

	std::string str = RTLIL::unescape_id(sig.wire->name);
	for (size_t i = 0; i < str.size(); i++)
		if (str[i] == '#' || str[i] == '=' || str[i] == '<' || str[i] == '>')
			str[i] = '?';

	if (sig.wire->width != 1)
		str += stringf("[%d]", sig.wire->upto ? sig.wire->start_offset+sig.wire->width-sig.offset-1 : sig.wire->start_offset+sig.offset);

	cstr_buf.push_back(str);
	return cstr_buf.back().c_str();
}



void dump_const(std::ostream &f, const RTLIL::Const &data, int width = -1, int offset = 0, bool no_decimal = false, bool set_signed = false, bool escape_comment = false)
{
	if (width < 0)
		width = data.bits.size() - offset;
	if ((data.flags & RTLIL::CONST_FLAG_STRING) == 0 || width != (int)data.bits.size()) {
		if (width == 32 && !no_decimal) {
			int32_t val = 0;
			for (int i = offset+width-1; i >= offset; i--) {
				log_assert(i < (int)data.bits.size());
				if (data.bits[i] != RTLIL::S0 && data.bits[i] != RTLIL::S1)
					goto dump_hex;
				if (data.bits[i] == RTLIL::S1)
					val |= 1 << (i - offset);
			}
			if (set_signed && val < 0)
				f << stringf("-32'sd%u", -val);
			else
				f << stringf("32'%sd%u", set_signed ? "s" : "", val);
		} else {
dump_hex:
			vector<char> bin_digits, hex_digits;
			for (int i = offset; i < offset+width; i++) {
				log_assert(i < (int)data.bits.size());
				switch (data.bits[i]) {
				    case RTLIL::S0: bin_digits.push_back('0'); break;
				    case RTLIL::S1: bin_digits.push_back('1'); break;
				    case RTLIL::Sx: bin_digits.push_back('x'); break;
				    case RTLIL::Sz: bin_digits.push_back('z'); break;
				    case RTLIL::Sa: bin_digits.push_back('z'); break;
				    case RTLIL::Sm: log_error("Found marker state in final netlist.");
				}
			}
			if (GetSize(bin_digits) == 0)
				goto dump_bin;
			while (GetSize(bin_digits) % 4 != 0)
				if (bin_digits.back() == '1')
					bin_digits.push_back('0');
				else
					bin_digits.push_back(bin_digits.back());
			for (int i = 0; i < GetSize(bin_digits); i += 4)
			{
				char bit_3 = bin_digits[i+3];
				char bit_2 = bin_digits[i+2];
				char bit_1 = bin_digits[i+1];
				char bit_0 = bin_digits[i+0];
				if (bit_3 == 'x' || bit_2 == 'x' || bit_1 == 'x' || bit_0 == 'x') {
					if (bit_3 != 'x' || bit_2 != 'x' || bit_1 != 'x' || bit_0 != 'x')
						goto dump_bin;
					hex_digits.push_back('x');
					continue;
				}
				if (bit_3 == 'z' || bit_2 == 'z' || bit_1 == 'z' || bit_0 == 'z') {
					if (bit_3 != 'z' || bit_2 != 'z' || bit_1 != 'z' || bit_0 != 'z')
						goto dump_bin;
					hex_digits.push_back('z');
					continue;
				}
				int val = 8*(bit_3 - '0') + 4*(bit_2 - '0') + 2*(bit_1 - '0') + (bit_0 - '0');
				hex_digits.push_back(val < 10 ? '0' + val : 'a' + val - 10);
			}
			f << stringf("%d'%sh", width, set_signed ? "s" : "");
			for (int i = GetSize(hex_digits)-1; i >= 0; i--)
				f << hex_digits[i];
		}
		if (0) {
dump_bin:
			f << stringf("%d'%sb", width, set_signed ? "s" : "");
			if (width == 0)
				f << stringf("0");
			for (int i = offset+width-1; i >= offset; i--) {
				log_assert(i < (int)data.bits.size());
				switch (data.bits[i]) {
				    case RTLIL::S0: f << stringf("0"); break;
				    case RTLIL::S1: f << stringf("1"); break;
				    case RTLIL::Sx: f << stringf("x"); break;
				    case RTLIL::Sz: f << stringf("z"); break;
				    case RTLIL::Sa: f << stringf("z"); break;
				    case RTLIL::Sm: log_error("Found marker state in final netlist.");
				}
			}
		}
	} else {
		f << stringf("\"");
		std::string str = data.decode_string();
		for (size_t i = 0; i < str.size(); i++) {
			if (str[i] == '\n')
				f << stringf("\\n");
			else if (str[i] == '\t')
				f << stringf("\\t");
			else if (str[i] < 32)
				f << stringf("\\%03o", str[i]);
			else if (str[i] == '"')
				f << stringf("\\\"");
			else if (str[i] == '\\')
				f << stringf("\\\\");
			else if (str[i] == '/' && escape_comment && i > 0 && str[i-1] == '*')
				f << stringf("\\/");
			else
				f << str[i];
		}
		f << stringf("\"");
	}
}

void dump_sigchunk(std::ostream &f, const RTLIL::SigChunk &chunk, bool no_decimal = false)
{
	if (chunk.wire == NULL) {
		dump_const(f, chunk.data, chunk.width, chunk.offset, no_decimal);
	} else {
		if (chunk.width == chunk.wire->width && chunk.offset == 0) {
			f << stringf("%s", log_id(chunk.wire->name));
		} else if (chunk.width == 1) {
			if (chunk.wire->upto)
				f << stringf("%s[%d]", log_id(chunk.wire->name), (chunk.wire->width - chunk.offset - 1) + chunk.wire->start_offset);
			else
				f << stringf("%s[%d]", log_id(chunk.wire->name), chunk.offset + chunk.wire->start_offset);
		} else {
			if (chunk.wire->upto)
				f << stringf("%s[%d:%d]", log_id(chunk.wire->name),
						(chunk.wire->width - (chunk.offset + chunk.width - 1) - 1) + chunk.wire->start_offset,
						(chunk.wire->width - chunk.offset - 1) + chunk.wire->start_offset);
			else
				f << stringf("%s[%d:%d]", log_id(chunk.wire->name),
						(chunk.offset + chunk.width - 1) + chunk.wire->start_offset,
						chunk.offset + chunk.wire->start_offset);
		}
	}
}

void dump_sigspec(std::ostream &f, const RTLIL::SigSpec &sig)
{
	if (sig.is_chunk()) {
		dump_sigchunk(f, sig.as_chunk());
	} else {
		f << stringf("{ ");
		for (auto it = sig.chunks().rbegin(); it != sig.chunks().rend(); ++it) {
			if (it != sig.chunks().rbegin())
				f << stringf(", ");
			dump_sigchunk(f, *it, true);
		}
		f << stringf(" }");
	}
}


void dump_cell(std::ostream &f, std::string indent, RTLIL::Cell *cell)
{
	//dump_attributes(f, indent, cell->attributes);
	f << stringf("%s" "%s", indent.c_str(), log_id(cell->type));
    f << stringf(" gg%d (", name_map[log_id(cell->name)]);

	bool first_arg = true;
	for (auto &conn : cell->connections()){
        std::string wire_name = "";
        RTLIL::SigSpec newsig = conn.second;
        log_assert(newsig.size() == 1); // make sure size is one
        assign_map.apply(newsig);
        if (!first_arg)
            f << stringf(",");
        if (signal_map.count(newsig) > 0)
            wire_name = stringf("n%d", signal_map[newsig]);
        else {
            std::stringstream conn_name;
			dump_sigspec(conn_name, newsig);
			wire_name = conn_name.str();
		}
        f << stringf( " .%s(%s)", cstr(conn.first), wire_name.c_str());
        first_arg = false;
    }
    f << stringf(");\n");
}
void dump_wire(std::stringstream &f, std::string indent, RTLIL::Wire *wire)
{
    std::vector<std::string> wire_names;

    for (int bit_it = 0; bit_it < wire->width; bit_it++)
    {
        RTLIL::SigSpec sig = RTLIL::SigSpec(wire);
        RTLIL::SigBit bit = sig[bit_it];
        assign_map.apply(bit);
        if (signal_map.count(bit) > 0){
            wire_names.push_back(stringf(" n%d", signal_map[bit]));
            f << stringf("// wire %s is mapped to n%d\n",id(wire->name).c_str(),signal_map[bit]);
        }
        else
            if (wire->width != 1 && signal_map.count(bit) <= 0)
                wire_names.push_back(stringf(" x%d",extra_wires_count++));
            else
                wire_names.push_back(string(id(wire->name)));
    }

    if (wire->port_input && !wire->port_output)
        for (unsigned int i=0; i<wire_names.size(); i++) {
            f << stringf("%s" "input%s;\n", indent.c_str(), wire_names[i].c_str());
        }
    if (!wire->port_input && wire->port_output)
        for (unsigned int i=0; i<wire_names.size(); i++) {
            f << stringf("%s" "output%s;\n", indent.c_str(), wire_names[i].c_str());
        }
    if (wire->port_input && wire->port_output)
        for (unsigned int i=0; i<wire_names.size(); i++) {
            f << stringf("%s" "inout%s;\n", indent.c_str(), wire_names[i].c_str());
        }
    else if (!wire->port_input && !wire->port_output)
        for (unsigned int i=0; i<wire_names.size(); i++)
        {
                f << stringf("%s" "wire%s;\n", indent.c_str(), wire_names[i].c_str());
        }
}

void dump_module(std::stringstream &f, std::string indent, RTLIL::Module *module)
{
	f << stringf("%s" "module netlist(", indent.c_str());
	bool keep_running = true;
	bool printed = false;
	for (int port_id = 1; keep_running; port_id++) {
		keep_running = false;
		for (auto &it : module->wires_) {
			RTLIL::Wire *wire = it.second;
			if (wire->port_id == port_id) {
			    for (int bit_it = 0; bit_it < wire->width; bit_it++) {
                    RTLIL::SigSpec sigspec = RTLIL::SigSpec(wire);
                    RTLIL::SigBit bit = sigspec[bit_it];
                    assign_map.apply(bit);
				    if (printed)
                        f << stringf(", ");
                    if (signal_map.count(bit) > 0)
                    {
				        f << stringf("n%d", signal_map[bit]);
                    }
                    else
                    {
				        f << stringf("%s", log_id(wire->name));
                    }
                    printed = true;
				    keep_running = true;
				    continue;
				}
			}
		}
	}
	f << stringf(");\n");

	for (auto it = module->wires_.begin(); it != module->wires_.end(); ++it)
		dump_wire(f, indent + "  ", it->second);

    f << "\n";

	for (auto it = module->cells_.begin(); it != module->cells_.end(); ++it)
		dump_cell(f, indent + "  ", it->second);

	f << stringf("%s" "\nendmodule\n", indent.c_str());
}

int add_to_signal_list(RTLIL::SigBit bit, bool is_port, bool is_reg_in, bool is_reg_out, bool is_PI, bool is_PO, bool is_comb)
{
	assign_map.apply(bit);

	if (signal_map.count(bit) == 0) {
		wire_t wire;
		wire.id = signal_list.size();
		wire.is_port = false;
		wire.is_reg_in = false;
		wire.is_reg_out = false;
		wire.is_PI = false;
		wire.is_PO = false;
        wire.is_comb = false;
		wire.bit = bit;
		if (signal_init.count(bit))
			wire.init = signal_init.at(bit);
		else
			wire.init = State::Sx;
		signal_list.push_back(wire);
		signal_map[bit] = wire.id;
	}
	wire_t &wire = signal_list[signal_map[bit]];

	if (is_port)
	    wire.is_port = true;
	if (is_reg_in)
	    wire.is_reg_in = true;
	if (is_reg_out)
	    wire.is_reg_out = true;
    if (is_PI)
        wire.is_PI = true;
    if (is_PO)
        wire.is_PO = true;
    if(is_comb)
        wire.is_comb = true;
    return wire.id;
}

void mark_primary_port(RTLIL::SigSpec sig, bool pi, bool po)
{
	for (auto &bit : assign_map(sig))
        if (bit.wire != NULL && signal_map.count(bit) > 0)
        {
			signal_list[signal_map[bit]].is_port = true;
			if (pi)
			    signal_list[signal_map[bit]].is_PI = true;
			if (po)
			    signal_list[signal_map[bit]].is_PO = true;
		}
}

void extract_cell(RTLIL::Cell *cell, std::stringstream &f,int counter, std::string clock_port)
{
    std::string cell_type = cell->type.str();
    name_map[log_id(cell->name)] = counter;

    if (!is_DFF(cell)){
        f << stringf("#gg%d\n",counter);
	    f << stringf(".gate %s", log_id(cell->type)); 
	    for (auto &conn : cell->connections()){
            RTLIL::SigSpec newsig = conn.second;
            log_assert(newsig.size() == 1); // make sure size is one
            assign_map.apply(newsig);
            add_to_signal_list(newsig, false, false, false, false, false, true);
            f << stringf( " %s=n%d", cstr(conn.first), signal_map[newsig]);
        }
		f << stringf("\n");
		return;
    }
    else{
        cell->simpleName = stringf("$gg%d\n",counter);
        RTLIL::SigSpec sig_d;
        if (cell->hasPort("\\D"))
            sig_d = cell->getPort("\\D");
        else
            log_cmd_error("DFF does not have a D port\n");

        assign_map.apply(sig_d);

        RTLIL::SigSpec sig_q;
        if(cell->hasPort("\\Q"))
            sig_q = cell->getPort("\\Q");
        RTLIL::SigSpec sig_qn;
        if(cell->hasPort("\\QN"))
            sig_qn = cell->getPort("\\QN");

        RTLIL::SigSpec sig_clk;
        clock_port = "\\" + clock_port;
        if(cell->hasPort(clock_port))
            sig_clk = cell->getPort(clock_port);

        log_assert(sig_d.size() == 1); // make sure size is one
        log_assert(sig_q.size() == 1 || sig_qn.size() == 1); // make sure size is one

        for (auto &conn : cell->connections())
        {
            RTLIL::SigSpec newsig = conn.second;
            log_assert(newsig.size() == 1); // make sure size is one
            if(newsig == sig_clk)
            {
                continue;
            }
            assign_map.apply(newsig);
            if(newsig == sig_q || newsig == sig_qn)
            {
                add_to_signal_list(newsig, true, false, true, false, false,false);
            }
            else
            {
                add_to_signal_list(newsig, true, true, false, false, false,false);
            }
        }
    }
}

std::string remap_name(RTLIL::IdString abc_name)
{
	std::stringstream sstr;
	sstr << "$abc$" << map_autoidx << "$" << abc_name.substr(1);
	return sstr.str();
}

std::string add_echos_to_abc_cmd(std::string str)
{
	std::string new_str, token;
	for (size_t i = 0; i < str.size(); i++) {
		token += str[i];
		if (str[i] == ';') {
			while (i+1 < str.size() && str[i+1] == ' ')
				i++;
			new_str += "echo + " + token + " " + token + " ";
			token.clear();
		}
	}

	if (!token.empty()) {
		if (!new_str.empty())
			new_str += "echo + " + token + "; ";
		new_str += token;
	}

	return new_str;
}

std::string fold_abc_cmd(std::string str)
{
	std::string token, new_str = "          ";
	int char_counter = 10;

	for (size_t i = 0; i <= str.size(); i++) {
		if (i < str.size())
			token += str[i];
		if (i == str.size() || str[i] == ';') {
			if (char_counter + token.size() > 75)
				new_str += "\n              ", char_counter = 14;
			new_str += token, char_counter += token.size();
			token.clear();
		}
	}

	return new_str;
}

std::string replace_tempdir(std::string text, std::string tempdir_name, bool show_tempdir)
{
	if (show_tempdir)
		return text;

	while (1) {
		size_t pos = text.find(tempdir_name);
		if (pos == std::string::npos)
			break;
		text = text.substr(0, pos) + "<abc-temp-dir>" + text.substr(pos + GetSize(tempdir_name));
	}

	std::string  selfdir_name = proc_self_dirname();
	if (selfdir_name != "/") {
		while (1) {
			size_t pos = text.find(selfdir_name);
			if (pos == std::string::npos)
				break;
			text = text.substr(0, pos) + "<yosys-exe-dir>/" + text.substr(pos + GetSize(selfdir_name));
		}
	}

	return text;
}

struct abc_output_filter
{
	bool got_cr;
	int escape_seq_state;
	std::string linebuf;
	std::string tempdir_name;
	bool show_tempdir;

	abc_output_filter(std::string tempdir_name, bool show_tempdir) : tempdir_name(tempdir_name), show_tempdir(show_tempdir)
	{
		got_cr = false;
		escape_seq_state = 0;
	}

	void next_char(char ch)
	{
		if (escape_seq_state == 0 && ch == '\033') {
			escape_seq_state = 1;
			return;
		}
		if (escape_seq_state == 1) {
			escape_seq_state = ch == '[' ? 2 : 0;
			return;
		}
		if (escape_seq_state == 2) {
			if ((ch < '0' || '9' < ch) && ch != ';')
				escape_seq_state = 0;
			return;
		}
		escape_seq_state = 0;
		if (ch == '\r') {
			got_cr = true;
			return;
		}
		if (ch == '\n') {
			log("ABC: %s\n", replace_tempdir(linebuf, tempdir_name, show_tempdir).c_str());
			got_cr = false, linebuf.clear();
			return;
		}
		if (got_cr)
			got_cr = false, linebuf.clear();
		linebuf += ch;
	}

	void next_line(const std::string &line)
	{
		int pi, po;
		if (sscanf(line.c_str(), "Start-point = pi%d.  End-point = po%d.", &pi, &po) == 2) {
			log("ABC: Start-point = pi%d (%s).  End-point = po%d (%s).\n",
					pi, pi_map.count(pi) ? pi_map.at(pi).c_str() : "???",
					po, po_map.count(po) ? po_map.at(po).c_str() : "???");
			return;
		}

		for (char ch : line)
			next_char(ch);
	}
};

void abc_module(RTLIL::Design *design, RTLIL::Module *current_module, std::string script_file, std::string innovus_script_file, std::string exe_file,
        std::string liberty_file, std::string constr_file, bool cleanup, std::string clk_str,
        std::string delay_target, const std::vector<RTLIL::Cell*> &cells, bool show_tempdir, bool phys_mode, std::string clk_port)
{
	module = current_module;
	map_autoidx = autoidx++;

	signal_map.clear();
	signal_list.clear();
	pi_map.clear();
	po_map.clear();
	recover_init = false;

	if (clk_str != "$")
	{
		clk_polarity = true;
		clk_sig = RTLIL::SigSpec();

		en_polarity = true;
		en_sig = RTLIL::SigSpec();
	}

	std::string tempdir_name = "/tmp/yosys-abc-XXXXXX";
	if (!cleanup)
		tempdir_name[0] = tempdir_name[4] = '_';
	tempdir_name = make_temp_dir(tempdir_name);
	log_header(design, "Extracting gate netlist of module `%s' to `%s/input.blif'..\n",
			module->name.c_str(), replace_tempdir(tempdir_name, tempdir_name, show_tempdir).c_str());

    // Writing the script file
	std::string abc_script = stringf("read_lib -w %s; ", liberty_file.c_str());
	abc_script += stringf("read_blif %s/input.blif; ", tempdir_name.c_str());

	if (!constr_file.empty())
		abc_script += stringf("read_constr -v %s; ", constr_file.c_str());

	if (!script_file.empty()) {
		if (script_file[0] == '+') {
			for (size_t i = 1; i < script_file.size(); i++)
				if (script_file[i] == '\'')
					abc_script += "'\\''";
				else if (script_file[i] == ',')
					abc_script += " ";
				else
					abc_script += script_file[i];
		} else
			abc_script += stringf("source %s", script_file.c_str());
	}
	else
		abc_script += phys_mode ? ABC_DXBXUX : ABC_DBU;

    //TODO add suport for -D flag.
    /*
	   if (script_file.empty() && !delay_target.empty())
	   for (size_t pos = abc_script.find("dretime;"); pos != std::string::npos; pos = abc_script.find("dretime;", pos+1))
	   abc_script = abc_script.substr(0, pos) + "dretime; retime -o {D};" + abc_script.substr(pos+8);
       */
	abc_script += stringf("; write_blif %s/output.blif", tempdir_name.c_str());
	abc_script = add_echos_to_abc_cmd(abc_script);

	for (size_t i = 0; i+1 < abc_script.size(); i++)
		if (abc_script[i] == ';' && abc_script[i+1] == ' ')
			abc_script[i+1] = '\n';

	FILE *f = fopen(stringf("%s/abc.script", tempdir_name.c_str()).c_str(), "wt");
	fprintf(f, "%s\n", abc_script.c_str());
	fclose(f);

    // Doing the extraction of cells.
    std::stringstream gates_sstr;
    int counter = 1;
    for (auto c : cells)
    {
        extract_cell(c, gates_sstr,counter,clk_port);
        counter++;
	}

	for (auto &wire_it : module->wires_) {
		if (wire_it.second->port_id > 0 || wire_it.second->get_bool_attribute("\\keep")){
		   	mark_primary_port(RTLIL::SigSpec(wire_it.second), wire_it.second->port_input, wire_it.second->port_output);
		}
	}

    if(phys_mode)
    {
        // Writing Verilog
        std::stringstream v_sstr;
        dump_module(v_sstr, "", module);
        std::string buffer = stringf("%s/netlist.v", tempdir_name.c_str());
        f = fopen(buffer.c_str(), "wt");
        if (f == NULL)
            log_error("Opening %s for writing failed: %s\n", buffer.c_str(), strerror(errno));
        fprintf(f, "%s\n", v_sstr.str().c_str());
        fclose(f);


        // Run Replace and FP

        // Step 0B: Calculate design area
        double module_area = 0;

        for (auto &it : module->cells_)
        {
            if (!design->selected(module, it.second))
                continue;

            RTLIL::IdString cell_type = it.second->type;

            if (!cell_area.empty()) {
                if (cell_area.count(cell_type))
                    module_area += cell_area.at(cell_type);
                else{
                    log("Area for cell type %s is unknown! Cell not counted toward total area!\n", cell_type.c_str());
                }
            }
        }

        FloorPlanandPlace(tempdir_name, innovus_script_file, log_id(module->name), module_area);

    }

	for (auto c : cells){
        std::string cell_type = c->type.str();
        if (!is_DFF(c)){
		    module->remove(c);
        }
    }

    // Writing input.blif
    std::string buffer = stringf("%s/input.blif", tempdir_name.c_str());
	f = fopen(buffer.c_str(), "wt");
	if (f == NULL)
		log_error("Opening %s for writing failed: %s\n", buffer.c_str(), strerror(errno));

	fprintf(f, ".model netlist\n");

	int count_input = 0;
	fprintf(f, ".inputs");
    for (auto &si : signal_list)
    {
        if ((si.is_PI) || (si.is_reg_out && !si.is_PO) || (si.is_PO && si.is_comb && si.is_reg_out) )
        {
            assign_map.apply(si.bit);
            fprintf(f, " n%d", si.id);
            pi_map[count_input++] = log_signal(si.bit);
        }
    }
	if (count_input == 0)
		fprintf(f, " dummy_input\n");
	fprintf(f, "\n");

	int count_output = 0;
	fprintf(f, ".outputs");
    for (auto &si : signal_list)
    {
        if ((si.is_PO && !si.is_comb && si.is_reg_out) || (si.is_PO && si.is_comb && !si.is_reg_out) || (si.is_reg_in && !si.is_PI))
        {
            assign_map.apply(si.bit);
            fprintf(f, " n%d", si.id);
            po_map[count_output++] = log_signal(si.bit);
        }
    }

	fprintf(f, "\n");
    fprintf(f, "%s\n", gates_sstr.str().c_str());
	fprintf(f, ".end\n");
	fclose(f);

    // FIXME Correct the number of stuff...
	//log("Extracted %d gates and %d wires to a netlist network with %d inputs and %d outputs.\n",
	//		count_gates, GetSize(signal_list), count_input, count_output);
	log_push();

	if (count_output > 0)
	{
		log_header(design, "Executing ABC as part of Physical Flow.\n");

        // Running ABC
		buffer = stringf("%s -s -f %s/abc.script 2>&1", exe_file.c_str(), tempdir_name.c_str());
		log("Running ABC command: %s\n", replace_tempdir(buffer, tempdir_name, show_tempdir).c_str());

#ifndef YOSYS_LINK_ABC
		abc_output_filter filt(tempdir_name, show_tempdir);
		int ret = run_command(buffer, std::bind(&abc_output_filter::next_line, filt, std::placeholders::_1));
#else
		// These needs to be mutable, supposedly due to getopt
		char *abc_argv[5];
		string tmp_script_name = stringf("%s/abc.script", tempdir_name.c_str());
		abc_argv[0] = strdup(exe_file.c_str());
		abc_argv[1] = strdup("-s");
		abc_argv[2] = strdup("-f");
		abc_argv[3] = strdup(tmp_script_name.c_str());
		abc_argv[4] = 0;
		int ret = Abc_RealMain(4, abc_argv);
		free(abc_argv[0]);
		free(abc_argv[1]);
		free(abc_argv[2]);
		free(abc_argv[3]);
#endif
		if (ret != 0)
			log_error("ABC: execution of command \"%s\" failed: return code %d.\n", buffer.c_str(), ret);

        buffer = stringf("%s/%s", tempdir_name.c_str(), "output.blif");
		std::ifstream ifs;
		ifs.open(buffer);
		if (ifs.fail())
			log_error("Can't open ABC output file `%s'.\n", buffer.c_str());

		bool builtin_lib = liberty_file.empty();
		RTLIL::Design *mapped_design = new RTLIL::Design;
        parse_blif(mapped_design, ifs, builtin_lib ? "\\DFF" : "\\_dff_", false, false, false, true);

		ifs.close();

		log_header(design, "Re-integrating ABC results.\n");
		RTLIL::Module *mapped_mod = mapped_design->modules_["\\netlist"];
		if (mapped_mod == NULL)
			log_error("ABC output file does not contain a module `netlist'.\n");

		for (auto &it : mapped_mod->wires_) {
			RTLIL::Wire *w = it.second;
			RTLIL::Wire *wire = module->addWire(remap_name(w->name));
			if (markgroups) wire->attributes["\\abcgroup"] = map_autoidx;
			design->select(module, wire);
		}

		std::map<std::string, int> cell_stats;
		for (auto c : mapped_mod->cells())
		{
			cell_stats[RTLIL::unescape_id(c->type)]++;

            if (c->type == "\\_const0_" || c->type == "\\_const1_") // this happens when a regout is directly connected to a PO, input.blif contains a flooting outPin, so ABC forces it to be constant of value 0
                continue;

            RTLIL::Cell *cell = module->addCell(log_id(c->name), c->type);
            cell->simpleName = c->name;
			if (markgroups) cell->attributes["\\abcgroup"] = map_autoidx;
			cell->parameters = c->parameters;
			for (auto &conn : c->connections()) {
				RTLIL::SigSpec newsig;
				for (auto &c : conn.second.chunks()) {
					if (c.width == 0)
						continue;
					log_assert(c.width == 1);
					newsig.append(module->wires_[remap_name(c.wire->name)]);
				}
				cell->setPort(conn.first, newsig);
			}
			design->select(module, cell);
		}

		for (auto conn : mapped_mod->connections()) {
			if (!conn.first.is_fully_const())
				conn.first = RTLIL::SigSpec(module->wires_[remap_name(conn.first.as_wire()->name)]);
			if (!conn.second.is_fully_const())
				conn.second = RTLIL::SigSpec(module->wires_[remap_name(conn.second.as_wire()->name)]);
			module->connect(conn);
		}

		for (auto &it : cell_stats)
			log("ABC RESULTS:   %15s cells: %8d\n", it.first.c_str(), it.second);
		int in_wires = 0, out_wires = 0;
        for (auto &si : signal_list)
			if (si.is_port) {
				char buffer[100];
				snprintf(buffer, 100, "\\n%d", si.id);
				RTLIL::SigSig conn;
		        if (si.is_reg_out) {
					conn.first = si.bit;
					conn.second = RTLIL::SigSpec(module->wires_[remap_name(buffer)]);
					out_wires++;
		        } 
		        if (si.is_reg_in) {
					conn.first = RTLIL::SigSpec(module->wires_[remap_name(buffer)]);
					conn.second = si.bit;
					in_wires++;
				} 
				if (si.is_PO) {
					conn.first = RTLIL::SigSpec(module->wires_[remap_name(buffer)]);
					conn.second = si.bit;
					out_wires++;
		        } 
		        if (si.is_PI) {
					conn.first = si.bit;
					conn.second = RTLIL::SigSpec(module->wires_[remap_name(buffer)]);
					in_wires++;
				}
                module->connect(conn);
			}
		log("ABC RESULTS:        internal signals: %8d\n", int(signal_list.size()) - in_wires - out_wires);
		log("ABC RESULTS:           input signals: %8d\n", in_wires);
		log("ABC RESULTS:          output signals: %8d\n", out_wires);

		delete mapped_design;
	}
	else
	{
		log("Don't call ABC as there is nothing to map.\n");
	}

	if (cleanup)
	{
		log("Removing temp directory.\n");
		remove_directory(tempdir_name);
	}

	log_pop();
}

struct Phys_abcPass : public Pass {
    Phys_abcPass() : Pass("phys_abc", "use ABC for technology mapping") { }
	void help() YS_OVERRIDE
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    abc [options] [selection]\n");
		log("\n");
		log("This pass uses the ABC tool [1] for technology mapping of yosys's internal gate\n");
		log("library to a target architecture.\n");
		log("\n");
		log("    -exe <command>\n");
#ifdef ABCEXTERNAL
		log("        use the specified command instead of \"" ABCEXTERNAL "\" to execute ABC.\n");
#else
		log("        use the specified command instead of \"<yosys-bindir>/yosys-abc\" to execute ABC.\n");
#endif
		log("        This can e.g. be used to call a specific version of ABC or a wrapper.\n");
		log("\n");
		log("    -script <file>\n");
		log("        use the specified ABC script file instead of the default script.\n");
		log("\n");
		log("        if <file> starts with a plus sign (+), then the rest of the filename\n");
		log("        string is interpreted as the command string to be passed to ABC. The\n");
		log("        leading plus sign is removed and all commas (,) in the string are\n");
		log("        replaced with blanks before the string is passed to ABC.\n");
		log("\n");
		log("        if no -script parameter is given, the following scripts are used:\n");
        log("\n");
		log("        for -liberty without -constr:\n");
		log("%s\n", fold_abc_cmd(ABC_DXBXUX).c_str());
        log("\n");
        log("    -innovus_script <file>\n");
        log("        use the specified Innovus script for floor planning and placement.\n");
        log("        The script shouldn't contain \"set init_verilog\" as it is set internally by yosys.\n");
        log("        if this flag is not set, RePlace is used instead.\n");
        log("\n");
		log("    -liberty <file>\n");
		log("        generate netlists for the specified cell library (using the liberty\n");
		log("        file format).\n");
		log("\n");
		log("    -constr <file>\n");
		log("        pass this file with timing constraints to ABC. use with -liberty.\n");
		log("\n");
		log("        a constr file contains two lines:\n");
		log("            set_driving_cell <cell_name>\n");
		log("            set_load <floating_point_number>\n");
		log("\n");
		log("        the set_driving_cell statement defines which cell type is assumed to\n");
		log("        drive the primary inputs and the set_load statement sets the load in\n");
		log("        femtofarads for each primary output.\n");
		log("\n");
		log("    -D <picoseconds>\n");
		log("        set delay target. the string {D} in the default scripts above is\n");
		log("        replaced by this option when used, and an empty string otherwise.\n");
		log("        this also replaces 'dretime' with 'dretime; retime -o {D}' in the\n");
		log("        default scripts above.\n");
		log("\n");
		log("    -I <num>\n");
		log("        maximum number of SOP inputs.\n");
		log("        (replaces {I} in the default scripts above)\n");
		log("\n");
		log("    -P <num>\n");
		log("        maximum number of SOP products.\n");
		log("        (replaces {P} in the default scripts above)\n");
		log("\n");
		log("    -S <num>\n");
		log("        maximum number of LUT inputs shared.\n");
		log("        (replaces {S} in the default scripts above, default: -S 1)\n");
		log("\n");
		log("    -nocleanup\n");
		log("        when this option is used, the temporary files created by this pass\n");
		log("        are not removed. this is useful for debugging.\n");
		log("\n");
		log("    -showtmp\n");
		log("        print the temp dir name in log. usually this is suppressed so that the\n");
		log("        command output is identical across runs.\n");
		log("\n");
		log("    -markgroups\n");
		log("        set a 'abcgroup' attribute on all objects created by ABC. The value of\n");
		log("        this attribute is a unique integer for each ABC process started. This\n");
		log("        is useful for debugging the partitioning of clock domains.\n");
		log("\n");
        log("    -clk_port\n");
        log("        set the name of the clock port for the flip flops in the used liberty file.\n");
        log("\n");
		log("    -no_phys\n");
		log("        Do not use the physical flow. Yosys will not pass -x flags to ABC.\n");
		log("        This flag is only relevant if no -script flag is used.\n");
		log("\n");
		log("[1] http://www.eecs.berkeley.edu/~alanmi/abc/\n");
		log("\n");
	}
	void execute(std::vector<std::string> args, RTLIL::Design *design) YS_OVERRIDE
	{
		log_header(design, "Executing Physical ABC pass (Physical Synthesis using ABC + RePlAce).\n");
		log_push();

		assign_map.clear();
		signal_list.clear();
		signal_map.clear();
		signal_init.clear();
		pi_map.clear();
		po_map.clear();

#ifdef ABCEXTERNAL
		std::string exe_file = ABCEXTERNAL;
#else
		std::string exe_file = proc_self_dirname() + "yosys-abc";
#endif
        std::string script_file, innovus_script_file, liberty_file, constr_file, clk_str, clk_port;
        std::string delay_target;
        bool cleanup = true;
		bool show_tempdir = false;
		bool phys_mode = true;
		markgroups = false;


#ifdef _WIN32
#ifndef ABCEXTERNAL
		if (!check_file_exists(exe_file + ".exe") && check_file_exists(proc_self_dirname() + "..\\yosys-abc.exe"))
			exe_file = proc_self_dirname() + "..\\yosys-abc";
#endif
#endif

		size_t argidx;
		char pwd [PATH_MAX];
		if (!getcwd(pwd, sizeof(pwd))) {
			log_cmd_error("getcwd failed: %s\n", strerror(errno));
			log_abort();
		}
		for (argidx = 1; argidx < args.size(); argidx++) {
			std::string arg = args[argidx];
			if (arg == "-exe" && argidx+1 < args.size()) {
				exe_file = args[++argidx];
				continue;
			}
			if (arg == "-script" && argidx+1 < args.size()) {
				script_file = args[++argidx];
				rewrite_filename(script_file);
				if (!script_file.empty() && !is_absolute_path(script_file) && script_file[0] != '+')
					script_file = std::string(pwd) + "/" + script_file;
				continue;
			}
            if (arg == "-innovus_script" && argidx+1 < args.size()) {
                innovus_script_file = args[++argidx];
                rewrite_filename(innovus_script_file);
                if (!innovus_script_file.empty() && !is_absolute_path(innovus_script_file) && innovus_script_file[0] != '+')
                    innovus_script_file = std::string(pwd) + "/" + innovus_script_file;
                continue;
            }
			if (arg == "-liberty" && argidx+1 < args.size()) {
				liberty_file = args[++argidx];
				rewrite_filename(liberty_file);
				if (!liberty_file.empty() && !is_absolute_path(liberty_file))
					liberty_file = std::string(pwd) + "/" + liberty_file;
				read_liberty_cellarea(cell_area, liberty_file);
				continue;
			}
			if (arg == "-constr" && argidx+1 < args.size()) {
				rewrite_filename(constr_file);
				constr_file = args[++argidx];
				if (!constr_file.empty() && !is_absolute_path(constr_file))
					constr_file = std::string(pwd) + "/" + constr_file;
				continue;
			}
			if (arg == "-D" && argidx+1 < args.size()) {
				delay_target = "-D " + args[++argidx];
				continue;
			}
			if (arg == "-nocleanup") {
				cleanup = false;
				continue;
			}
			if (arg == "-showtmp") {
				show_tempdir = true;
				continue;
			}
			if (arg == "-markgroups") {
				markgroups = true;
				continue;
			}
			if (arg == "-no_phys") {
				phys_mode  = false;
				continue;
            }
            if (arg == "-clk_port" && argidx+1 < args.size()) {
                clk_port = args[++argidx];
                continue;
            }
			break;
		}
		extra_args(args, argidx, design);

        if (!constr_file.empty() && liberty_file.empty())
			log_cmd_error("Got -constr but no -liberty!\n");

        if (clk_port.empty())
            log_cmd_error("-clk_port should be set.n");

		for (auto mod : design->selected_modules())
		{

			if (mod->processes.size() > 0) {
				log("Skipping module %s as it contains processes.\n", log_id(mod));
				continue;
			}

			assign_map.set(mod);
			signal_init.clear();

            abc_module(design, mod, script_file, innovus_script_file, exe_file, liberty_file, constr_file, cleanup, clk_str,
                    delay_target, mod->selected_cells(), show_tempdir, phys_mode, clk_port);

		}

		assign_map.clear();
		signal_list.clear();
		signal_map.clear();
		signal_init.clear();
		pi_map.clear();
		po_map.clear();

		log_pop();
	}
} AbcPass;

PRIVATE_NAMESPACE_END
