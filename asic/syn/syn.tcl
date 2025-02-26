#######################################################
#                                                     
#  THE RECIPE
#  by Sandro Bonacini
#  CERN PH/ESE/ME
#  Created on 10/07/2009
#                                                     
#######################################################
################################################
# Leakage/Dynamic power/Clock Gating setup
################################################

set_attribute max_leakage_power 0.0 "$ec::DESIGN"

#####################################################################
# synthesize -to_generic -effort $ec::SYN_EFFORT
#####################################################################
set_attribute remove_assigns true /
set_remove_assign_options -verbose

# ptk 250225 -- genus 231 doesn't like "synthesize" any more
#synthesize -to_generic -effort $ec::SYN_EFFORT
syn_gen
report datapath > $ec::reportDir/datapath_generic.rpt

################################################
# Synthesizing to gates
################################################

# ptk 250225 -- genus 231 doesn't like "synthesize" any more
#synthesize -to_mapped -eff $ec::MAP_EFFORT -no_incr
set_attribute syn_map_effort $ec::MAP_EFFORT
syn_map
puts "Runtime & Memory after 'synthesize -to_map -no_incr'"
report datapath > $ec::reportDir/datapath_mapped.rpt
