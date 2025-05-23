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

async def load_pulse(tb_amem, csv_path, column, metadata):
    """
    Load a pulse from a given CSV column with specified metadata.
    """
    tb_amem.amem_core_tb.metadata.value = metadata
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
            tb_amem.amem_core_tb.TOT.value = pulse
        tb_amem.amem_core_tb.TOT.value = 0  # Ensure TOT is low at the end

@cocotb.test()
async def test_amem_csv(tb_amem):
    """
    Test analog memory core with pulses from CSV.
    """
    csv_path = os.path.join(os.path.dirname(__file__), '../../waveforms/eos_wbls_thorium_tot.csv')

    # Initial setup
    tb_amem.amem_core_tb.TOT.value = 0
    tb_amem.amem_core_tb.resetb_full.value = 0
    tb_amem.amem_core_tb.metadata.value = 0x00
    await Timer(100, 'ns')

    # Reset pulse
    tb_amem.amem_core_tb.resetb_full.value = 1
    await Timer(50, 'ns')
    tb_amem.amem_core_tb.resetb_full.value = 0
    await Timer(100, 'ns')

    # Load each test case
    await load_pulse(tb_amem, csv_path, "SinglePE", 0x87)
    await Timer(200, 'ns')
    await load_pulse(tb_amem, csv_path, "DoublePE", 0x55)
    await Timer(200, 'ns')
    await load_pulse(tb_amem, csv_path, "MultiPE", 0xff)
    await Timer(200, 'ns')
    await load_pulse(tb_amem, csv_path, "Ringing", 0x33)
    await Timer(200, 'ns')

