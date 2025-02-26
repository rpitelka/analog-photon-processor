#######################################################
#                                                     
#  THE RECIPE
#  by Sandro Bonacini
#  CERN PH/ESE/ME
#  Created on 10/07/2009
#                                                     
#######################################################

if {[catch {

	source init.tcl
	source syn.tcl
	source syn2.tcl

	#####################################################################
	# BEGIN POSTAMBLE: DO NOT EDIT

	# Write the netlist
	write -m > $ec::outDir/r2g.v

	# Write SDC file
	write_sdc > $ec::outDir/r2g.sdc

	# Write RC script file
	# ptk 250225 Genus 231 doesn't like write_script
	#write_script > $ec::outDir/r2g.g
	write_db -common $ec::outDir/r2g.g

	# Write LEC file
	#write_do_lec -no_exit -revised_design $ec::outDir/r2g.v  >../../lec/scripts/rtl2map.tcl
	write_do_lec -no_exit -revised_design $ec::outDir/r2g.v  > $ec::outDir/rtl2map.tcl

	# END POSTAMBLE
	#####################################################################


	#####################################################################
	# Noload/zero-load analysis on final result
	#####################################################################

	report timing -full


	# end timer
	puts "\nEC INFO: End at: [clock format [clock seconds] -format {%x %X}]"
	set ec::end [clock seconds]
	set ec::seconds [expr $ec::end - $ec::start]
	puts "\nEC INFO: Elapsed-time: $ec::seconds seconds\n"

	# done
	#exit

} msg]} {
	puts "\nEC ERROR: RC could not finish successfully. Force an exit now. ($msg)\n"
	#exit -822
}

