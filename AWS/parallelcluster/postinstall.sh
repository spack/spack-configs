#!/bin/bash
set -e

##############################################################################################
# # This script will setup Spack and best practices for a few applications.                  #
# # Use as postinstall in AWS ParallelCluster (https://docs.aws.amazon.com/parallelcluster/) #
##############################################################################################

# Install onto first shared storage device
cluster_config="/opt/parallelcluster/shared/cluster-config.yaml"
[ -f "${cluster_config}" ] && {
    os=$(python << EOF
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

    cfn_ebs_shared_dirs=$(python << EOF
#/usr/bin/env python
import yaml
with open("${cluster_config}", 'r') as s:
    print(yaml.safe_load(s)["SharedStorage"][0]["MountDir"])
EOF
                       )
    scheduler=$(python << EOF
#/usr/bin/env python
import yaml
with open("${cluster_config}", 'r') as s:
    print(yaml.safe_load(s)["Scheduling"]["Scheduler"])
EOF
                )
} || . /etc/parallelcluster/cfnconfig || {
    echo "Cannot find ParallelCluster configs"
    echo "Installing Spack into /shared/spack for ec2-user."
    cfn_ebs_shared_dirs="/shared"
    cfn_cluster_user="ec2-user"
}

install_path=${SPACK_ROOT:-"${cfn_ebs_shared_dirs}/spack"}
# For now we use specific commits as markers as the last release is too old and
# develop changes too fast.
# spack_branch="develop"
# Commit from Thu Jan 19 16:01:31 2023 +0100
spack_commit="45ea7c19e5"

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

major_version() {
    pcluster_version=$(grep -oE '[0-9]*\.[0-9]*\.[0-9]*' /opt/parallelcluster/.bootstrapped)
    echo "${pcluster_version/\.*}"
}

# Make first user owner of Spack installation when script exits.
fix_owner() {
    rc=$?
    if [ -z "${SPACK_ROOT}" ]
    then
        chown -R ${cfn_cluster_user}:${cfn_cluster_user} "${install_path}"
    fi
    exit $rc
}
trap "fix_owner" SIGINT EXIT

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
        break
    fi
}

set_pcluster_defaults() {
    # Set versions of pre-installed software in packages.yaml
    SLURM_VERSION=$(. /etc/profile && sinfo --version | cut -d' ' -f 2 | sed -e 's?\.?-?g')
    LIBFABRIC_MODULE=$(. /etc/profile && module avail libfabric 2>&1 | grep libfabric | head -n 1 | xargs )
    LIBFABRIC_MODULE_VERSION=$(. /etc/profile && module avail libfabric 2>&1 | grep libfabric | head -n 1 |  cut -d / -f 2 | sed -e 's?~??g' | xargs )
    LIBFABRIC_VERSION=${LIBFABRIC_MODULE_VERSION//amzn*}
    GCC_VERSION=$(gcc -v 2>&1 |tail -n 1| awk '{print $3}' )

    # Write the above as actual yaml file and only parse the \$.
    mkdir -p ${install_path}/etc/spack

    # Find suitable packages.yaml. If not for this architecture then for its parents.
    download_packages_yaml "$(target)"
    eval "echo \"$(cat /tmp/packages.yaml)\"" > ${install_path}/etc/spack/packages.yaml

    for f in mirrors modules config; do
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
    spack buildcache keys --install --trust
}

install_packages() {
    . /opt/slurm/etc/slurm.sh || . /etc/profile.d/spack.sh

    # Compiler needed for all kinds of codes. It makes no sense not to install it.
    # Get gcc from buildcache
    spack install gcc
    (
        spack load gcc
        spack compiler add --scope site
    )

    if [ "x86_64" == "$(architecture)" ]
    then
        # Add oneapi@latest & intel@latest
        spack install intel-oneapi-compilers-classic
        (
            . "$(spack location -i intel-oneapi-compilers)/setvars.sh"
            spack compiler add --scope site
        )
    fi

    # Install any specs provided to the script.
    for spec in "$@"
    do
        spack install -U "${spec}"
    done
}

if [ "3" != "$(major_version)" ]; then
    echo "ParallelCluster version $(major_version) not supported."
    exit 1
fi

download_spack |& tee -a /var/log/spack-postinstall.log
set_pcluster_defaults |& tee -a /var/log/spack-postinstall.log
setup_spack |& tee -a /var/log/spack-postinstall.log
install_packages "$@" |& tee -a /var/log/spack-postinstall.log
