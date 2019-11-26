# Default values
SPACK_ROOT ?= ~spack/spack
MODULE_DIR ?= /soft/environment/modules/modulefiles
MODULE_FILE ?= latest
ALCF_SYSTEM_NAME ?= theta
CURATED_MODULES_DIR ?= /soft/spack/alcf/theta/modulefiles/spack-curated

default:
	@echo
	@echo Current Settings:
	@echo
	@echo "SPACK_ROOT=${SPACK_ROOT}"
	@echo "MODULE_DIR=${MODULE_DIR}"
	@echo "MODULE_FILE=${MODULE_FILE}"
	@echo "ALCF_SYSTEM_NAME=${ALCF_SYSTEM_NAME}"
	@echo "CURATED_MODULES_DIR=${CURATED_MODULES_DIR}"
	@echo
	@echo "Targets: "
	@echo
	@echo " - install: yamls and modules "
	@echo " - install-yamls: just configuration "
	@echo " - install-modules: just modules "
	@echo " - multiuser-test: requires sudo, will build and install the multiuser test"
	@echo " - check: runs all installation tests"
	@echo
	@echo "What do you want to do?"
	@echo

install: install-yamls install-modules

install-yamls: 
	[ -e ${SPACK_ROOT}/etc/spack ] && cp ${ALCF_SYSTEM_NAME}/*.yaml ${SPACK_ROOT}/etc/spack
	[ -e ${SPACK_ROOT}/etc/spack ] && rm -rf ${SPACK_ROOT}/etc/spack/cray
	[ -e ${SPACK_ROOT}/etc/spack ] && mkdir ${SPACK_ROOT}/etc/spack/cray
	[ -e ${SPACK_ROOT}/etc/spack/cray ] && cp ${ALCF_SYSTEM_NAME}/cray/*.yaml ${SPACK_ROOT}/etc/spack/cray

# build and install the spack module and spack-curated module
install-modules:
	[ -e ${MODULE_DIR}/spack ] || mkdir -p ${MODULE_DIR}/spack
	sed -e "s#SPACK_ROOT_GOES_HERE#${SPACK_ROOT}#g" < ${ALCF_SYSTEM_NAME}/modulefiles/spack.in > ${MODULE_DIR}/spack/${MODULE_FILE} 
	[ -e ${MODULE_DIR}/spack-curated ] || mkdir -p ${MODULE_DIR}/spack-curated
	sed -e "s#CURATED_MODULES_DIR_GOES_HERE#${CURATED_MODULES_DIR}#g" < ${ALCF_SYSTEM_NAME}/modulefiles/spack-curated.in > ${MODULE_DIR}/spack-curated/${MODULE_FILE} 

multiuser-test:
	cd tests/src && make install_multiuser_dummy
	cd tests/src && sudo make install 

check: 
	@echo "Checking installation... "
	SPACK_ROOT=${SPACK_ROOT} \
	MODULE_DIR=${MODULE_DIR} \
	MODULE_FILE=${MODULE_FILE} \
	ALCF_SYSTEM_NAME=${ALCF_SYSTEM_NAME} \
	cd tests && ./run_tests.sh 


