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
async def basic_access_test(dut):
	"""Try accessing the design."""
	await Timer(1000, 'ns')
