#!/bin/bash

export FAILURES=0

. setup.sh

newline=$(printf "\n");

export FAILING_TESTS="$newline"

for i in `ls test_*.sh` 
do
    printf "\n\n\n\t***** BEGIN TESTING: $i *****\n\n\n\n"
    . `pwd`/$i

    if [ $? == 0 ]
    then 
        pass
    else 
        fail
        export FAILING_TESTS="$FAILING_TESTS$newline$i" 
#        export FAILURES=`expr $? + $FAILURES`
        export FAILURES=`expr 1 + $FAILURES`
    fi

    printf "\n\n\n\t***** END TESTING: $i *****\n\n\n\n"
done

echo "$FAILURES failures."
echo
echo $FAILING_TESTS
echo

echo "done."

