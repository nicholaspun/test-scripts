#!/bin/bash
run_test()
{
 filein="testSuite/$1"
 WLP4SCAN=$(mktemp /tmp/cs241output.XXXX)
 TEMPOUT=$(mktemp /tmp/output.XXX)

 if ! [ -r $filein ]; then
	 >&2 echo "Error: Test $1 missing or unreadable"
	 exit 2
 fi

 wlp4scan < $filein > $WLP4SCAN 2> /dev/null
 racket wlp4scan.rkt < $filein > $TEMPOUT

 cmp -s $WLP4SCAN $TEMPOUT
 if [ $? -eq 1 ]; then
	 echo "Test failed: $1"
	 diff $WLP4SCAN $TEMPOUT
	 echo "Input:"
	 cat $filein
	 echo "Expected:"
	 cat $WLP4SCAN
	 echo "Actual:"
	 cat $TEMPOUT
 else
		 echo "Test: $1 passed"
 fi

 rm $WLP4SCAN $TEMPOUT
}


if [ $# -eq 1 ]; then
 	run_test $1
else
	for input in $(ls testSuite); do
		run_test $input
	done
fi



echo "All tests run"
