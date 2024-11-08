# The Yosys script for synthesizing logic

yosys -import


global env
global argv

if {!([info exists env(UTDTOOLS)])} {
  puts stderr "ERROR:cannot get UTD Tools environment variable:UTDTOOLS"
  exit 1
}
source [file join $env(UTDTOOLS) yosys tcl init.tcl]
source ./design.init

if {!([file exists output])} {
  file mkdir output
}
if {!([file exists rpt])} {
  file mkdir rpt
}

set dsn $::utdtools::designNameS
set rtl_all $::utdtools::rtl_allS
set outputDir "./output"
set vtop $::utdtools::vtopS
set clock $::utdtools::clockS

#if {[file exists $outputDir]} {
#    exec rm -rf $outputDir
#}
#exec mkdir $outputDir
#exec mkdir $outputDir/LS

#if {[file exists $runDir/rpt]} {
#    exec rm -rf $runDir/rpt
#}
#exec mkdir ./rpt

set sclib $::utdtools::timing_fileS
set constr_file $::utdtools::sdc_fileS
# FIX LATER
#set constr_file "riscv.sdc"

set opt 1

# Don't change these unless you know what you are doing
set stat_ext    "_stat.rep"
set gl_ext      "_gl.v"
#set constr_ext  ".$clock.constr"
set timing_ext  ".timing.txt"
set abc_ext     ".abc"

set rpt_file "$dsn$timing_ext"
set stat_file "$dsn$stat_ext"
#set constr_file "$dsn$constr_ext"


#set   outfile [open "$dsn$constr_ext" w]
#puts  $outfile "set_driving_cell $driving_cell"
#puts  $outfile "set_load $cap_load"
#close $outfile


# ABC Scrips
set abc_rs_K    "resub,-K,"
set abc_rs      "resub"
set abc_rsz     "resub,-z"
set abc_rw_K    "rewrite,-K,"
set abc_rw      "rewrite"
set abc_rwz     "rewrite,-z"
set abc_rf      "refactor"
set abc_rfz     "refactor,-z"
set abc_b       "balance"


set abc_resyn2        "${abc_b}; ${abc_rw}; ${abc_rf}; ${abc_b}; ${abc_rw}; ${abc_rwz}; ${abc_b}; ${abc_rfz}; ${abc_rwz}; ${abc_b}"
set abc_share         "strash; multi,-m; ${abc_resyn2}"

set abc_resyn2a       "${abc_b};${abc_rw};${abc_b};${abc_rw};${abc_rwz};${abc_b};${abc_rwz};${abc_b}"
set abc_resyn3        "balance;resub;resub,-K,6;balance;resub,-z;resub,-z,-K,6;balance;resub,-z,-K,5;balance"
set abc_resyn2rs      "${abc_b};${abc_rs_K},6;${abc_rw};${abc_rs_K},6,-N,2;${abc_rf};${abc_rs_K},8;${abc_rw};${abc_rs_K},10;${abc_rwz};${abc_rs_K},10,-N,2;${abc_b},${abc_rs_K},12;${abc_rfz};${abc_rs_K},12,-N,2;${abc_rwz};${abc_b}"
set compress2rs       "${abc_b},-l; ${abc_rs_K},6,-l; ${abc_rw},-l; ${abc_rs_K},6,-N,2,-l; ${abc_rf},-l; ${abc_rs_K},8,-l; ${abc_b}, -l; ${abc_rs_K},8,-N,2,-l; ${abc_rw},-l; ${abc_rs_K},10,-l; ${abc_rsz}, -l; ${abc_rs_K},10, -N, 2, -l; ${abc_b}, -l; ${abc_rs_K}, 12, -l; ${abc_rfz}, -l; ${abc_rs_K},12,-N,2,-l; ${abc_rwz}, -l; ${abc_b}, -l"

set ms_opt            "strash; dch,-f; ${abc_resyn2}; strash; dch,-f; ${abc_resyn2}; strash; dch,-f; ${abc_resyn2}; strash; dch,-f;${abc_resyn2rs};"
set ms_opt__          "strash; dch,-f; ${abc_resyn2}; strash; dch,-f; ${abc_resyn2rs};"
set ms_opt_           "strash; dch,-f; ${abc_resyn2};retime,-o,{D};"
set ms_opt2           "${ms_opt};${ms_opt}"
set ms_opt4_          "${ms_opt2};${ms_opt2}"
set ms_opt4           "${ms_opt}"
set ms_opt8           "${ms_opt4};${ms_opt4}"

set abc_map_new       "amap,-m,-Q,0.2,-F,50,-A,50,-C,1000"
set abc_map_old       "map,-p,-B,0.88,-A,0.0,-M,1,{D},-F,0,-f"
set abc_old_opt       "strash; dc2,-b,-l,-p;ifraig"
set abc_new_opt       "strash;dch,-p;ifraig"
set abc_retime_area   "retime,-D,{D},-M,3"
set abc_retime_dly    "retime,-D,{D},-M,6"
set abc_fine_tune     "buffer;upsize,{D}; dnsize,{D}; "


set abc_script  "+read_constr,${constr_file};strash;ifraig;retime,-D,{D},-M,6;strash;dch,-f;map,-p,-M,1,{D},-f;retime,-D,{D};buffer; upsize,{D};dnsize,{D};stime,-p;"

# read design
foreach rtl_file $rtl_all {
    read_verilog "${rtl_file}"
}

hierarchy -check -top $vtop
#alumacc
#if {$schematic==1} {
#  json -o "${dsn}.json"
#}

synth  -top $vtop -flatten

if {$opt==0} {
  share -aggressive
  opt
  share -aggressive
  opt
  share -aggressive
  opt
}

opt_clean -purge
dfflibmap -liberty $sclib

#design -save myDesign
puts "ABC: WireLoad : abc_script"
#design -load myDesign



if {$opt==1} {
    abc -D $clock -constr "$constr_file" -liberty $sclib  -script $abc_script
  } else {
      abc -D $clock -constr "$constr_file" -liberty $sclib
  }

  #tee -o timing.txt abc -script "+stime,-p,-a"
  #write_blif -gates -noalias tmp.blif

  opt_clean -purge
  write_verilog -noattr -noexpr "$outputDir/${dsn}.v"

  tee -o "./rpt/$dsn.$clock$stat_ext" stat -top $vtop -liberty $sclib

