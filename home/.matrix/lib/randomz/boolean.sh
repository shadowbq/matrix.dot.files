# Generate binary choice, that is, "true" or "false" value.

function booleanwrapper {
	BINARY=2
	T=1
	number=$RANDOM

	let "number %= $BINARY"

	if [ "$number" -eq $T ]
	then
	  if [ -z $NO_CR ]; then
	          echo "TRUE"
	  else
	          echo -n "TRUE"
	  fi
	else
	  if [ -z $NO_CR ]; then
	          echo "FALSE"
	  else
	          echo -n "FALSE"
	  fi
	fi  

}
