# analog-photon-processor

## Maintainter

Adrian Nikolica (nikolica@hep.upenn.edu)

## Contributors
* Adrian Nikolica
* Paul T. Keener
* Ravi C. Pitelka

## Desription
Digital core design for APP ASIC. FPGA code for test PCB.

### Directory Structure 
|      |      |
| :--- | :--- |
| fpga/constr/ | Vivado pin constraints |
| fpga/sim/ | Top level Verilog testbenches, cocotb unit testbenches |
| fpga/src/ | Verilog source files for FPGA |
| asic/syn/ | Synthesis scripts |
| asic/verif/ | Unit level cocotb testbenches |
| asic/verilog/ | Verilog source files for chip |
| verif/ | Top level cocotb testbenches for running ASIC+FPGA |

### Setup (ASIC)
Setup assumes you are running on lxhiggs (CentOS7) which is required for the ASIC tools to run. Because of this, we are limited to python v2.7.5, which limits us to cocotb v1.3.1 outside of a virtual environment.
`./create_cocotb_venv.sh` to set up virtual environment with Python 3.11 and latest cocotb version. Defaults to installing in home directory.

#### Environment
1. ~~`source .cshrc_Cadence_Linux` to set up the Cadence ASIC tool environment.~~
   `source .min_231-env.csh` to set up the Cadence ASIC tool environment.
#### Simulation
1. From the verif/ directory, `./run_venv.sh`.  This will start cocotb in the virtual environment, and bring up the Incisive tool (NCSim simulation, and SimVision GUI waveform viewer). 
2. For asic simulation: from the asic/verif directory, `./run.sh`. This will start cocotb in a virtual environment. To run with gui, `env GUI=1 ./run.sh`. By default, skips all tests; `env RUN_ALL=1 ./run.sh` to run all tests or `env APP_TXX=1 ./run.sh` to run a specific test. Current tests:
* `APP_T01` Basic demonstration for analog behavorial model
* `APP_T02` Load pulses from CSV into analog behavorial model
* `APP_T03` Basic test for analog memory core
#### Synthesis
1. From the asic/syn directory, `./run_syn.sh`. This will create an output directory with the synthesized Verilog and timing files.

### Setup (FPGA)

#### Git workflow and building firmware
Setup assumes you are running Vivado 2022.2 in a Linux environment
1. Open Vivado, and in the Tcl Console, navigate to the fpga/ directory.
2. `source test.tcl` will build the entire project from scratch, including block diagram.
3. Clicking Run Simulation from the side panel will open a GUI simulation window.

#### Building petalinux

## Documentation

## Notes

