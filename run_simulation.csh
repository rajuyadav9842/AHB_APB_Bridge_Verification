#!/bin/csh

source /home/install/cshrc

xrun \
-clean \
-input probe.tcl \
-uvm \
./rtl_top.sv testbench.sv \
-access \
+rwc
exit
