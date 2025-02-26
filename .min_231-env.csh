
#
# BASE - Virtuoso
#
set path=($path /cad/IC231/tools/bin /cad/IC231/tools/dfII/bin)

#
# DRC & LVS
#
set path=($path /cad/PEGASUS232/tools/bin)

#
# Extraction
#
set path=($path /cad/QUANTUS231/tools/bin)

#
# PNR - Innovus
#
set path=($path /cad/DDI231/INNOVUS231/tools/bin)

#
# logic synthesis - Genus
#
set path=($path /cad/DDI231/GENUS231/tools/bin)

#
# HDL simulation = Xcelium
#
set path=($path /cad/XCELIUM2403/tools/bin)

#
# TECHNOLOGY
#

# TSMC 65nm
setenv TSMC_PDK /cad/Technology/TSMC650A/V1.7A_1/1p9m6x1z1u
