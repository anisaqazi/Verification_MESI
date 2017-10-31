#Tcl script which can be used with JasperGold
#Use "source lab4.tcl" in the console to source this script

#Reading the files 
analyze -verilog {../rtl/mesi_isc_basic_fifo.v} ; 
analyze -verilog {../rtl/mesi_isc_breq_fifos_cntl.v} ; 
analyze -verilog {../rtl/mesi_isc_breq_fifos.v} ; 
analyze -verilog {../rtl/mesi_isc_broad_cntl.v} ; 
analyze -verilog {../rtl/mesi_isc_broad.v} ; 
analyze -verilog {../rtl/mesi_isc_define.v} ; 
analyze -verilog {../rtl/mesi_isc.v};
analyze -sv {mesi_isc_assertion.sv};

#Elaborating the design
elaborate -top {mesi_isc};

#You will need to add commands below
#Set the clock
clock -clear; clock clk

#Set Reset
reset -expression {rst};

#Prove all
prove -bg -all
