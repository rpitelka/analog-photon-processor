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

async def load_pulse(tb_behav, csv_path, column):
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
            tb_behav.app_tb.vcomp.value = pulse
        tb_behav.app_tb.vcomp.value = 0  # Ensure vcomp is low at the end

@cocotb.test()
async def test_behav_csv(tb_behav):
    """
    Test behavioral model by sequentially playing SinglePE, DoublePE, MultiPE, and Ringing pulses from CSV.
    """
    csv_path = os.path.join(os.path.dirname(__file__), '../../waveforms/eos_wbls_thorium_tot.csv')

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

    # Play each test case
    await load_pulse(tb_behav, csv_path, "SinglePE")
    await Timer(200, 'ns')
    await load_pulse(tb_behav, csv_path, "DoublePE")
    await Timer(200, 'ns')
    await load_pulse(tb_behav, csv_path, "MultiPE")
    await Timer(200, 'ns')
    await load_pulse(tb_behav, csv_path, "Ringing")
    await Timer(200, 'ns')

