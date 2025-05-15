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
async def test_behav_basic(tb_behav):
    """
    Basic demonstration for behavioral model of analog section.
    Generates a number of TOT events.
    """
    # Initial setup
    tb_behav.app_tb.vcomp = 0
    tb_behav.app_tb.rst_init = 0
    
    # Wait after initial setup
    await Timer(110, 'ns')
    
    # Reset pulse
    tb_behav.app_tb.rst_init = 1
    await Timer(50, 'ns')
    tb_behav.app_tb.rst_init = 0
    await Timer(100, 'ns')

    # Single TOT pulse test
    tb_behav.app_tb.vcomp = 1
    await Timer(10, 'ns')
    tb_behav.app_tb.vcomp = 0
    await Timer(100, 'ns')

    # Multiple TOT pulses test
    for i in range(3):
        tb_behav.app_tb.vcomp = 1
        await Timer(10, 'ns')
        tb_behav.app_tb.vcomp = 0
        await Timer(15, 'ns')
    
    await Timer(100, 'ns')

    for i in range(6):
        tb_behav.app_tb.vcomp = 1
        await Timer(10, 'ns')
        tb_behav.app_tb.vcomp = 0
        await Timer(15, 'ns')
    
    await Timer(100, 'ns')

    # Single TOT pulse test
    tb_behav.app_tb.vcomp = 1
    await Timer(10, 'ns')
    tb_behav.app_tb.vcomp = 0
    await Timer(200, 'ns')
