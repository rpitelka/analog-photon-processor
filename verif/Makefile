PYTHONPATH = $(shell printenv PYTHONPATH):../../cocotb/:$(shell pwd)/
SIM ?= ius

VERILOG_SOURCES+=   ../asic/amem_core.v \
		    ../asic/tb_amem.v

TOPLEVEL = tb
TOPLEVEL_LANG ?= verilog
MODULE = tb_amem_cocotb
GUI=0

include $(shell cocotb-config --makefiles)/Makefile.sim
