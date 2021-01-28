# test_spec_no_package.sh

echo "Attempting to spec a package which does not exist... "
echo "If the spec fails, this test will pass. "

spack spec no-such-package

if [ "$?" == "0" ]
then
    return 1
else
    return 0
fi
