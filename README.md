# analog-photon-processor

## Maintainter

Adrian Nikolica (nikolica@hep.upenn.edu)

## Contributors
* Adrian Nikolica
* Paul T. Keener
*

## Desription
Digital core design for APP ASIC. FPGA code for test PCB.

### Directory Structure 
|      |      |
| :--- | :--- |
| fpga/constr/ | Vivado pin constraints |
| fpga/sim/ | Top level Verilog testbenche, cocotb unit testbenches |
| fpga/src/ | Verilog source files for FPGA |
| asic/syn/ | Synthesis scripts |
| asic/verif/ | Unit level cocotb testbenches |
| asic/verilog/ | Verilog source files for chip |
| verif/ | Top level cocotb testbenches for running ASIC+FPGA |

### Setup (ASIC)
Setup assumes you are running on lxhiggs (CentOS7) which is required for the ASIC tools to run. Because of this, we are limited to python v2.7.5, which limits us to cocotb v1.3.1.

1. ~~`source .cshrc_Cadence_Linux` to set up the Cadence ASIC tool environment.~~
2. `source .min_231-env.csh` to set up the Cadence ASIC tool environment.
3. From the verif/ directory, `./run.sh`.  This will start cocotb, and bring up the Incisive tool (NCSim simulation, and SimVision GUI waveform viewer). 

### Setup (FPGA)

#### Git workflow and building firmware
Setup assumes you are running Vivado 2022.2 in a Linux environment
1. Open Vivado, and in the Tcl Console, navigate to the fpga/ directory.
2. `source test.tcl` will build the entire project from scratch, including block diagram.
3. Clicking Run Simulation from the side panel will open a GUI simulation window.

#### Building petalinux

## Documentation

## Notes

