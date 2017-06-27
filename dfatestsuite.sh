#!/bin/bash

if [ $# -ne 1 ]; then
  >&2 echo "Error: $0 takes in exactly 1 arguments"
  exit 1
fi

dfa="$1.dfa"

for input in $(ls tests | grep $1.*.in); do
	filein="tests/$input"
  fileout="${filein%.in}.out"
  TEMP_OUT=$(mktemp /tmp/output.XXX)
	TEMP_DFA=$(mktemp /tmp/dfatemp.XXXX)

  cp $dfa $TEMP_DFA
  cat $filein >> $TEMP_DFA

	java cs241.DFA < $TEMP_DFA > $TEMP_OUT

  diff $TEMP_OUT $fileout
	cmp -s $TEMP_OUT $fileout
	if [ $? -eq 1 ]; then
		echo "Test failed:" "$input"
		echo "Input:"
		cat $filein
		echo "Expected: $fileout"
		cat $fileout
		echo "Actual:"
		cat $TEMP_OUT
	else
	  	echo "Test:" "$input" "passed"
	fi
	rm $TEMP_OUT $TEMP_DFA
done

echo "All tests run"
