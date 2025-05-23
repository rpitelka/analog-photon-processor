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
async def test_amem_basic(tb_amem):
    """
    Basic test for analog memory core.
    Tests reset behavior and TOT pulses with different metadata values.
    """
    # Initial setup
    tb_amem.amem_core_tb.TOT.value = 0
    tb_amem.amem_core_tb.resetb_full.value = 0
    tb_amem.amem_core_tb.metadata.value = 0x00
    
    # Wait after initial setup
    await Timer(100, 'ns')
    
    # Reset pulse
    tb_amem.amem_core_tb.resetb_full.value = 1
    await Timer(50, 'ns')
    tb_amem.amem_core_tb.resetb_full.value = 0
    await Timer(100, 'ns')

    # Single TOT pulse test
    tb_amem.amem_core_tb.metadata.value = 0x87
    tb_amem.amem_core_tb.TOT.value = 1
    await Timer(10, 'ns')
    tb_amem.amem_core_tb.TOT.value = 0
    await Timer(200, 'ns')

    # Multiple TOT pulses test
    for i in range(8):
        tb_amem.amem_core_tb.TOT.value = 1
        await Timer(10, 'ns')
        tb_amem.amem_core_tb.TOT.value = 0
        await Timer(10, 'ns')
        tb_amem.amem_core_tb.metadata.value = 0xff

    await Timer(200, 'ns')
