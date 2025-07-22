PYTHONPATH = $(shell printenv PYTHONPATH):../../cocotb/:$(shell pwd)/
SIM ?= ius

VERILOG_SOURCES+=   ../verilog/amem_core.v \
            ../verilog/app_1ch_behav.v \
            ../verilog/clock_div.v \
            ../verilog/oneshot.v \
            ../verilog/oneshot_dynamic.v \
		    APP_tb.v

TOPLEVEL = APP_tb
TOPLEVEL_LANG ?= verilog
MODULE = APP_cocotb

include $(shell cocotb-config --makefiles)/Makefile.sim
