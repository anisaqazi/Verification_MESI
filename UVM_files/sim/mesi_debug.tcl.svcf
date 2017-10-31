
# NC-Sim Command File
# TOOL:	ncsim(64)	13.20-s034
#
#
# You can restore this configuration with:
#
#      irun -top top -svseed 1 -input source.tcl -l irun.elab.log -uvm -sv -access +rwc -uvmhome /usr/local/packages/cadence_2015/incisiv13.2/tools/uvm -incdir /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/rtl -incdir /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/tb -incdir /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/tb/uvm_tb -incdir /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/tb/uvm_tb/master_uvc -incdir /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/tb/uvm_tb/tests -cflags -I/home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/rtl -I/home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/tb -coverage functional -covdut top -covoverwrite /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/rtl/mesi_isc.v /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/rtl/mesi_isc_broad.v /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/rtl/mesi_isc_broad_cntl.v /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/rtl//mesi_isc_breq_fifos_cntl.v /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/rtl/mesi_isc_breq_fifos.v /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/rtl/mesi_isc_basic_fifo.v /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/tb/uvm_tb/master_uvc/master_uvc.sv /home/ecelrc/students/aqazi/Verif/Project/kamayni_files_v1/src/tb/uvm_tb/top.sv -covtest mycov_func1.cov -input mesi_debug.tcl
#

set tcl_prompt1 {puts -nonewline "ncsim> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1
alias . run
alias iprof profile
alias quit exit
stop -create -name Randomize -randomize
database -open -vcd -into ./dump.vcd _./dump.vcd1 -timescale fs
database -open -evcd -into ./dump.vcd _./dump.vcd -timescale fs
database -open -shm -into waves.shm waves -default
probe -create -database waves top -all -variables -memories -sc_processes -depth all -tasks -functions -uvm
probe -create -database waves $uvm:{uvm_test_top.mesi_env_h} -ports -depth all -tasks -functions -uvm
probe -create -database waves $uvm:{uvm_test_top.mesi_env_h.master0} -all -depth all

simvision -input mesi_debug.tcl.svcf
