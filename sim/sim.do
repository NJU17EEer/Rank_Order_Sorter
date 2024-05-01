transcript on
if {[file exists rtl_work]} {
    vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

set file_list [glob -nocomplain ../src/*.sv]
if {[llength $file_list] != 0} {
    vlog -sv -incr -timescale=1ns/1ns -lint -reportprogress 300 -work work {../src/*.sv}
}
set file_list [glob -nocomplain ../src/rtl/*.v]
if {[llength $file_list] != 0} {
    vlog -incr -timescale=1ns/1ns -lint -reportprogress 300 -work work {../src/*.v}
}
vlog -incr -sv -reportprogress 300 -work work {./*.sv}
vsim -voptargs="+acc" -t 1ns work.tb -vopt
if {[file exists wave.do]} {
    do ./wave.do
} else {
    add wave -noupdate -expand -group tb -height 30 -radixshowbase 0 -radix binary -internal /tb/*
    add wave -divider ""
    set uut_list [find instances /tb/*]
    for {set i 0} {$i < [llength $uut_list]} {incr i} {
        set uut_name [lindex [lindex $uut_list $i] 0]
        set signals "${uut_name}/*"
        add wave -noupdate -expand -group ${uut_name} -height 30 -radixshowbase 0 -radix binary -color Orange -in ${signals}
        add wave -noupdate -expand -group ${uut_name} -height 30 -radixshowbase 0 -radix binary -color "Orange Red" -out ${signals}
        if {[llength [find signals -internal ${signals}]] != 0} {
            add wave -noupdate -expand -group ${uut_name} -height 30 -radixshowbase 0 -radix binary -internal ${signals}
        }
        add wave -noupdate -expand -group ${uut_name} -height 30 -radixshowbase 0 -radix ASCII /tb/cur_state_name
        add wave -divider ""
        set local_ins_list [find instances ${signals}]
        for {set j 0} {$j < [llength $local_ins_list]} {incr j} {
            set ins_name [lindex [lindex $local_ins_list $j] 0]
            set signals "${ins_name}/*"
            if {[llength [find signals -in ${signals}]] != 0} {
                add wave -noupdate -expand -group ${ins_name} -height 30 -radixshowbase 0 -radix binary -color Orange -in ${signals}
            }
            if {[llength [find signals -out ${signals}]] != 0} {
                add wave -noupdate -expand -group ${ins_name} -height 30 -radixshowbase 0 -radix binary -color "Orange Red" -out ${signals}
            }
            if {[llength [find signals -internal ${signals}]] != 0} {
                add wave -noupdate -expand -group ${ins_name} -height 30 -radixshowbase 0 -radix binary -internal ${signals}
            }
            add wave -noupdate -expand -group ${ins_name} -height 30 -radixshowbase 0 -radix ASCII /tb/cur_state_name
            add wave -divider ""
        }
    }
    configure wave -shortnames 1
}
configure wave -font {Verdana 10}
view structure
view signals
view covergroup
run -all
wave zoom full
