#!/usr/bin/env bash
function extend_help {
	cat <<EOM
 Randomz - GPLv3 Shadowbq, 2012. Based on GNU derived work. 
 
 Execution:
 
   randomz [RANDOMCONTROLS] [OUTPUTCONTROLS] [RUNTIMEOPTIONS] \$ARGS
 
 Notes:
   Randomz is based on \$RANDOM and is truely cross platform. It does not depend on any other languages
   present other than BASH v3.x or above. Randomz is SLOW, so COMPLEX Randomz is REALLY SLOW. Dont complain.  

 Random controls:
   -z				# Seed before execution (IMPORTANT)
				  - Default is to not reseed before every execution
 Output options:
   -e    			# Suppress new line

 Runtime options:
   -b    			# Generate binary choice, that is, "true" or "false"
   -A    			# Print a single UPPERCASE English letter
   -a    			# Print a single lowercase English letter
   -i  				# Print an integer from 0 to 9 
   -x  				# Print an integer from 0 to 100 
   -n  				# Print an integer from 0 to 32764 
   -r '\$min \$max \$divisible'	# Print an integer from \$min to \$max divisable by \$divisable
   -u 				# Print a large /dev/urandom integer 

 Complex Execution:

   Generate 5 lower case english letters
       for i in {1..5}; do echo -n \`./randomz -zea\`; done
   
   Generate Random length character strings < 100 in length
       for ((c=1; c<=\$(./randomz -zex); c++)); do echo -n \$(./randomz -zea); done

   Generate Random length number from 0 to 1x10^32764  
       for ((c=1; c<=\$(./randomz -zen); c++)); do echo -n \$(./randomz -zei); done

EOM
}
