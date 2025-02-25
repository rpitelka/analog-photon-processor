import sys
import random
import os

import cocotb 
from cocotb import triggers, result, utils, clock 
from cocotb.clock import Clock 
from cocotb.triggers import Timer, RisingEdge, FallingEdge, Edge 
from cocotb.result import TestSuccess, TestFailure, ReturnValue 
from cocotb.utils import get_sim_time

@cocotb.test()
def my_first_test(tb_amem):
	"""Try accessing the design."""
	tb_amem.amem_core_tb.TOT = 0
	tb_amem.amem_core_tb.resetb_full = 0
	tb_amem.amem_core_tb.metadata = 0x00;	
	yield Timer(100, units="ns")
	
	tb_amem.amem_core_tb.resetb_full = 1
	yield Timer(50, units="ns")
	tb_amem.amem_core_tb.resetb_full = 0
	yield Timer(100, units="ns")

	tb_amem.amem_core_tb.metadata = 0x87;	
	tb_amem.amem_core_tb.TOT = 1
	yield Timer(10, units="ns")
	tb_amem.amem_core_tb.TOT = 0
	yield Timer(200, units="ns")

	for i in range (0, 8):
		tb_amem.amem_core_tb.TOT = 1
		yield Timer(10, units="ns")
		tb_amem.amem_core_tb.TOT = 0
		yield Timer(10, units="ns")
		tb_amem.amem_core_tb.metadata = 0xff;	
	yield Timer(200, units="ns")
