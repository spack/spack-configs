#!/bin/bash
set -e

##############################################################################################
# # This script will setup Spack and best practices for a few applications.                  #
# # Use as postinstall in AWS ParallelCluster (https://docs.aws.amazon.com/parallelcluster/) #
##############################################################################################

install_in_foreground=false
while [ $# -gt 0 ]; do
    case $1 in
        -v )
            set -v
            shift
            ;;
        -fg )
            install_in_foreground=true
            shift
            ;;
        -nointel )
            export NO_INTEL_COMPILER=1
            shift
            ;;
        * )
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

setup_variables() {
    # Install onto first shared storage device
    cluster_config="/opt/parallelcluster/shared/cluster-config.yaml"
    if [ -f "${cluster_config}" ]; then
        pip3 install pyyaml
        os=$(python3 << EOF
#/usr/bin/env python
import yaml
with open("${cluster_config}", 'r') as s:
    print(yaml.safe_load(s)["Image"]["Os"])
EOF
          )

        case "${os}" in
            alinux*)
                cfn_cluster_user="ec2-user"
                ;;
            centos*)
                cfn_cluster_user="centos"
                ;;
            ubuntu*)
                cfn_cluster_user="ubuntu"
                ;;
            *)
                cfn_cluster_user=""
        esac

        cfn_ebs_shared_dirs=$(python3 << EOF
#/usr/bin/env python
import yaml
with open("${cluster_config}", 'r') as s:
    print(yaml.safe_load(s)["SharedStorage"][0]["MountDir"])
EOF
                           )
        scheduler=$(python3 << EOF
#/usr/bin/env python
import yaml
with open("${cluster_config}", 'r') as s:
    print(yaml.safe_load(s)["Scheduling"]["Scheduler"])
EOF
                 )
    elif [ -f /etc/parallelcluster/cfnconfig ]; then
        . /etc/parallelcluster/cfnconfig
    else
        echo "Cannot find ParallelCluster configs"
        cfn_ebs_shared_dirs=""
    fi

    # If we cannot find any shared directory, use $HOME of standard user
    if [ -z "${cfn_ebs_shared_dirs}" ]; then
        for cfn_cluster_user in ec2-user centos ubuntu; do
            [ -d "/home/${cfn_cluster_user}" ] && break
        done
        cfn_ebs_shared_dirs="/home/${cfn_cluster_user}"
    fi

    install_path=${SPACK_ROOT:-"${cfn_ebs_shared_dirs}/spack"}
    echo "Installing Spack into ${install_path}."
    spack_branch="develop"

    scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

major_version() {
    pcluster_version=$(grep -oE '[0-9]*\.[0-9]*\.[0-9]*' /opt/parallelcluster/.bootstrapped)
    echo "${pcluster_version/\.*}"
}

# Make first user owner of Spack installation when script exits.
fix_owner() {
    rc=$?
    if [ ${downloaded} -eq 0 ]
    then
        chown -R ${cfn_cluster_user}:${cfn_cluster_user} "${install_path}"
    fi
    exit $rc
}

download_spack() {
    if [ -z "${SPACK_ROOT}" ]
    then
        [ -d ${install_path} ] || \
            if [ -n "${spack_branch}" ]
            then
                git clone https://github.com/spack/spack -b ${spack_branch} ${install_path}
            elif [ -n "${spack_commit}" ]
            then
                git clone https://github.com/spack/spack ${install_path}
                cd ${install_path} && git checkout ${spack_commit}
            fi
        return 0
    else
        # Let the script know we did not download spack, so the owner will not be fixed on exit.
        return 1
    fi
}

architecture() {
    lscpu  | grep "Architecture:" | awk '{print $2}'
}

# zen3 EC2 instances (e.g. hpc6a) is misidentified as zen2 so zen3 packages are found under packages-zen2.yaml.
target() {
    (
        . ${install_path}/share/spack/setup-env.sh
        spack arch -t
    )
}

download_packages_yaml() {
    # $1: spack target
    . ${install_path}/share/spack/setup-env.sh
    target="${1}"
    curl -Ls https://raw.githubusercontent.com/spack/spack-configs/main/AWS/parallelcluster/packages-"${target}".yaml -o /tmp/packages.yaml
    if [ "$(cat /tmp/packages.yaml)" = "404: Not Found" ]; then
        # Pick up parent if current generation is not available
        for target in $(spack-python -c 'print(" ".join(spack.platforms.host().target("'"${target}"'").microarchitecture.to_dict()["parents"]))'); do
            if [ -z "${target}" ] ; then
                echo "Cannot find suitable packages.yaml"
                exit 1
            fi
            download_packages_yaml "${target}"
        done
    else
        # Exit "for target in ..." loop.
        break &>/dev/null
    fi
}

set_pcluster_defaults() {
    # Set versions of pre-installed software in packages.yaml
    [ -z "${SLURM_VERSION}" ] && SLURM_VERSION=$(strings /opt/slurm/lib/libslurm.so | grep  -e '^VERSION'  | awk '{print $2}'  | sed -e 's?"??g')
    [ -z "${LIBFABRIC_MODULE_VERSION}" ] && LIBFABRIC_MODULE_VERSION=$(grep 'Version:' /opt/amazon/efa/lib64/pkgconfig/libfabric.pc | awk '{print $2}')
    [ -z "${LIBFABRIC_MODULE}" ] && LIBFABRIC_MODULE="libfabric-aws/${LIBFABRIC_MODULE_VERSION}"
    [ -z "${LIBFABRIC_VERSION}" ] && LIBFABRIC_VERSION=${LIBFABRIC_MODULE_VERSION//amzn*}
    [ -z "${GCC_VERSION}" ] && GCC_VERSION=$(gcc -v 2>&1 |tail -n 1| awk '{print $3}' )

    # Write the above as actual yaml file and only parse the \$.
    mkdir -p ${install_path}/etc/spack

    # Find suitable packages.yaml. If not for this architecture then for its parents.
    ( download_packages_yaml "$(target)" )
    eval "echo \"$(cat /tmp/packages.yaml)\"" > ${install_path}/etc/spack/packages.yaml

    for f in modules config; do
        curl -Ls https://raw.githubusercontent.com/spack/spack-configs/main/AWS/parallelcluster/${f}.yaml -o ${install_path}/etc/spack/${f}.yaml
    done
}

setup_spack() {
    cd "${install_path}"

    # Load spack at login
    if [ -z "${SPACK_ROOT}" ]
    then
        case "${scheduler}" in
            slurm)
                echo -e "\n# Spack setup from Github repo spack-configs" >> /opt/slurm/etc/slurm.sh
                echo -e "\n# Spack setup from Github repo spack-configs" >> /opt/slurm/etc/slurm.csh
                echo ". ${install_path}/share/spack/setup-env.sh &>/dev/null || true" >> /opt/slurm/etc/slurm.sh
                echo ". ${install_path}/share/spack/setup-env.csh &>/dev/null || true" >> /opt/slurm/etc/slurm.csh
                ;;
            *)
                echo "WARNING: Spack will need to be loaded manually when ssh-ing to compute instances."
                echo ". ${install_path}/share/spack/setup-env.sh" > /etc/profile.d/spack.sh
                echo ". ${install_path}/share/spack/setup-env.csh" > /etc/profile.d/spack.csh
        esac
    fi

    . "${install_path}/share/spack/setup-env.sh"
    spack compiler add --scope site
    spack external find --scope site

    # Remove all autotools/buildtools packages. These versions need to be managed by spack or it will
    # eventually end up in a version mismatch (e.g. when compiling gmp).
    spack tags build-tools | xargs -I {} spack config --scope site rm packages:{}
    [ -z "${CI_PROJECT_DIR}" ] && spack mirror add --scope site "aws-pcluster" "https://binaries.spack.io/develop/aws-pcluster-$(target | sed -e 's?_avx512??1')"
    spack buildcache keys --install --trust
}

install_packages() {
    if [ -n "${SPACK_ROOT}" ]; then
        [ -f /opt/slurm/etc/slurm.sh ] && . /opt/slurm/etc/slurm.sh || . /etc/profile.d/spack.sh
    fi

    # Compiler needed for all kinds of codes. It makes no sense not to install it.
    # Get gcc from buildcache
    spack install gcc
    (
        spack load gcc
        spack compiler add --scope site
    )

    if [ -z "${NO_INTEL_COMPILER}" ] && [ "x86_64" == "$(architecture)" ]
    then
        # Add oneapi@latest & intel@latest
        spack install intel-oneapi-compilers-classic
        bash -c ". "$(spack location -i intel-oneapi-compilers)/setvars.sh"; spack compiler add --scope site"
    fi

    # Install any specs provided to the script.
    for spec in "$@"
    do
        [ -z "${spec}" ] || spack install -U "${spec}"
    done
}

if [ "3" != "$(major_version)" ]; then
    echo "ParallelCluster version $(major_version) not supported."
    exit 1
fi

tmpfile=$(mktemp)
echo "$(declare -pf)
    trap \"fix_owner\" SIGINT EXIT
    setup_variables
    download_spack | true
    downloaded=\${PIPESTATUS[0]}
    set_pcluster_defaults
    setup_spack
    install_packages \"$@\"
    echo \"*** Spack setup completed ***\"
    rm -f ${tmpfile}
" > ${tmpfile}

if ${install_in_foreground}; then
    bash ${tmpfile}
else
    nohup bash ${tmpfile} &> /var/log/spack-postinstall.log &
    disown -a
fi
