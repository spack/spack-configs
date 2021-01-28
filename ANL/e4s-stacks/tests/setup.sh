# Sourced script

if [ "y" != "$SPACK_TEST_SETUP_COMPLETE" ]
then
    export SPACK_TEST_SETUP_COMPLETE="y"

    echo
    echo "Setting up for tests, declaring functions, etc."
    echo

    fail()
    {
        echo "This test fails."
        return 1
    }

    pass()
    {
        echo "This test passes."
        return 0
    }

    if [ "$MODULE_FILE" = "" ]
    then 
        export MODULE_FILE=latest
    fi

#    if [ "$SPACK_ROOT" = "" ]
#    then
        module load spack/$MODULE_FILE
        . $SPACK_ROOT/share/spack/setup-env.sh
#    fi
fi


