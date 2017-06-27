#!/bin/bash

for input in $(ls testSuite); do
	filein="testSuite/$input"
	TEMPJAVA=$(mktemp /tmp/javaoutput.XXX)
	TEMPRKT=$(mktemp /tmp/rktoutput.XXX)

	if ! [ -r $filein ]; then 
		>&2 echo "Error: Test $input missing or unreadable"
		exit 2
	fi

	java cs241.binasm < $filein > $TEMPJAVA
	racket asm.rkt < $filein > $TEMPRKT
	
	cmp -s $TEMPJAVA $TEMPRKT
	if [ $? -eq 1 ]; then
		echo "Test failed:" "$input"
		echo "Input:"
		cat $filein
		echo "Expected:"
		xxd -b -c4 $TEMPJAVA
		echo "Actual:"
		xxd -b -c4 $TEMPRKT
	else
	  	echo "Test:" "$input" "passed"
	fi
	rm $TEMPJAVA $TEMPRKT
done

echo "All tests run" 
