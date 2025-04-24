#!/bin/bash

# Activate virtual environment
source "$HOME/cocotb-env/bin/activate"

# Prepend cocotb-config from the venv to the PATH
if [ -e "$VIRTUAL_ENV/bin/cocotb-config" ]; then
  export PATH="$VIRTUAL_ENV/bin:$PATH"
fi

# Cocotb runtime settings
export COCOTB_REDUCED_LOG_FMT=1
export PYTHONDONTWRITEBYTECODE=1
export IVERILOG_DUMPER=lxt2

# Get the correct share directory for this cocotb install
export COCOTB_SHARE_DIR="$(cocotb-config --share)"

# Run simulation build
make

