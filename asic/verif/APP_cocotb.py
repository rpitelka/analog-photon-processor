import sys
import random
import os
import csv

import cocotb 
from cocotb import triggers, result, utils, clock 
from cocotb.clock import Clock 
from cocotb.triggers import Timer, RisingEdge, FallingEdge, Edge 
from cocotb.result import TestSuccess, TestFailure, ReturnValue 
from cocotb.utils import get_sim_time

def env1(envvarname, checkval="1"):
    "return True if environment variable 'envvarname' equals value 'checkval'"
    value = os.environ.get(envvarname)
    return value == checkval

dont_run_all = not (os.environ.get("RUN_ALL", "") == "1")

@cocotb.test(skip=(dont_run_all and not env1("APP_T01")))
async def test_behav_basic(APP_tb):
    """
    Basic demonstration for behavioral model of analog section.
    Generates a number of TOT events.
    """
    # Initial setup
    APP_tb.app_1ch_tb.vcomp.value = 0
    APP_tb.app_1ch_tb.rst_init.value = 0
    APP_tb.app_1ch_tb.timeout_enable.value = 1
    APP_tb.app_1ch_tb.timeout_threshold.value = 5

    # Wait after initial setup
    await Timer(110, 'ns')
    
    # Reset pulse
    APP_tb.app_1ch_tb.rst_init.value = 1
    await Timer(50, 'ns')
    APP_tb.app_1ch_tb.rst_init.value = 0
    await Timer(100, 'ns')

    # Single TOT pulse test
    APP_tb.app_1ch_tb.vcomp.value = 1
    await Timer(10, 'ns')
    APP_tb.app_1ch_tb.vcomp.value = 0
    await Timer(100, 'ns')

    # Multiple TOT pulses test
    for i in range(3):
        APP_tb.app_1ch_tb.vcomp.value = 1
        await Timer(10, 'ns')
        APP_tb.app_1ch_tb.vcomp.value = 0
        await Timer(15, 'ns')
    
    await Timer(100, 'ns')

    for i in range(6):
        APP_tb.app_1ch_tb.vcomp.value = 1
        await Timer(10, 'ns')
        APP_tb.app_1ch_tb.vcomp.value = 0
        await Timer(15, 'ns')
    
    await Timer(100, 'ns')

    # Single TOT pulse test
    APP_tb.app_1ch_tb.vcomp.value = 1
    await Timer(10, 'ns')
    APP_tb.app_1ch_tb.vcomp.value = 0
    await Timer(200, 'ns')


async def load_pulse(APP_tb, csv_path, column):
    """
    Load a pulse from a given CSV column and drive vcomp.
    """
    with open(csv_path, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        prev_time = None
        for row in reader:
            time_ns = int(row['Time (ns)'])
            pulse = int(row[column])
            if prev_time is not None:
                wait_time = time_ns - prev_time
                await Timer(wait_time, 'ns')
            prev_time = time_ns
            APP_tb.app_1ch_tb.vcomp.value = pulse
        APP_tb.app_1ch_tb.vcomp.value = 0  # Ensure vcomp is low at the end


@cocotb.test(skip=(dont_run_all and not env1("APP_T02")))
async def test_behav_csv(APP_tb):
    """
    Test behavioral model by sequentially playing pulses from CSV.
    """
    csv_path = os.path.join(os.path.dirname(__file__), '../../waveforms/eos_wbls_thorium_tot.csv')

    # Initial setup
    APP_tb.app_1ch_tb.vcomp.value = 0
    APP_tb.app_1ch_tb.rst_init.value = 0
    APP_tb.app_1ch_tb.timeout_enable.value = 1
    APP_tb.app_1ch_tb.timeout_threshold.value = 5
    
    # Wait after initial setup
    await Timer(110, 'ns')
    
    # Reset pulse
    APP_tb.app_1ch_tb.rst_init.value = 1
    await Timer(50, 'ns')
    APP_tb.app_1ch_tb.rst_init.value = 0
    await Timer(100, 'ns')

    # Play each test case
    await load_pulse(APP_tb, csv_path, "SinglePE")
    await Timer(200, 'ns')
    await load_pulse(APP_tb, csv_path, "DoublePE")
    await Timer(200, 'ns')
    await load_pulse(APP_tb, csv_path, "MultiPE")
    await Timer(200, 'ns')
    await load_pulse(APP_tb, csv_path, "Ringing")
    await Timer(200, 'ns')


@cocotb.test(skip=(dont_run_all and not env1("APP_T03")))
async def test_amem_basic(APP_tb):
    """
    Basic test for analog memory core.
    Tests reset behavior and TOT pulses with different metadata values.
    """
    # Initial setup
    APP_tb.amem_core_tb.TOT.value = 0
    APP_tb.amem_core_tb.resetb_full.value = 0
    APP_tb.amem_core_tb.metadata.value = 0x00
    
    # Wait after initial setup
    await Timer(100, 'ns')
    
    # Reset pulse
    APP_tb.amem_core_tb.resetb_full.value = 1
    await Timer(50, 'ns')
    APP_tb.amem_core_tb.resetb_full.value = 0
    await Timer(100, 'ns')

    # Single TOT pulse test
    APP_tb.amem_core_tb.metadata.value = 0x87
    APP_tb.amem_core_tb.TOT.value = 1
    await Timer(10, 'ns')
    APP_tb.amem_core_tb.TOT.value = 0
    await Timer(200, 'ns')

    # Multiple TOT pulses test
    for i in range(8):
        APP_tb.amem_core_tb.TOT.value = 1
        await Timer(10, 'ns')
        APP_tb.amem_core_tb.TOT.value = 0
        await Timer(10, 'ns')
        APP_tb.amem_core_tb.metadata.value = 0xff

    await Timer(200, 'ns')
