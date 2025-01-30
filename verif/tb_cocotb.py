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

async def my_first_test(tb):
    """Try accessing the design."""

    for cycle in range(10):
        await Timer(1000, units="ns")

