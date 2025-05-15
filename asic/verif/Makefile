PYTHONPATH = $(shell printenv PYTHONPATH):../../cocotb/:$(shell pwd)/
SIM ?= ius

VERILOG_SOURCES+=   ../verilog/app_1ch_behav.v \
            ../verilog/clock_div.v \
            ../verilog/oneshot.v \
		    tb_behav.v

TOPLEVEL = tb_behav
TOPLEVEL_LANG ?= verilog
MODULE = tb_behav_cocotb

include $(shell cocotb-config --makefiles)/Makefile.sim
