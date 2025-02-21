PYTHONPATH = $(shell printenv PYTHONPATH):../../cocotb/:$(shell pwd)/
SIM ?= ius

VERILOG_SOURCES+=   ../fpga/src/top.v \
		    ../fpga/sim/tb.v

TOPLEVEL = tb
TOPLEVEL_LANG ?= verilog
MODULE = tb_cocotb
GUI=1

include $(shell cocotb-config --makefiles)/Makefile.sim
