#!/bin/bash

export FAILURES=0

. setup.sh

newline=$(printf "\n");
export FAILING_TESTS="$newline"

printf "\n\n\n\t***** BEGIN SINGLE TEST: $1 *****\n\n\n\n"
. `pwd`/$1

if [ $? == 0 ]
then 
        pass
else 
        fail
        export FAILING_TESTS="$FAILING_TESTS$1$newline" 
        export FAILURES=`expr 1 + $FAILURES`
fi

printf "\n\n\n\t***** END TESTING: $i *****\n\n\n\n"

echo "$FAILURES failures."
echo
echo $FAILING_TESTS
echo

echo "done."

