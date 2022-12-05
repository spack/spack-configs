#!/bin/bash
set -e

##############################################################################################
# # This script will setup Spack on ParallelCluster compute nodes                            #
# # Use as postinstall in AWS ParallelCluster (https://docs.aws.amazon.com/parallelcluster/) #
##############################################################################################

# TODO: Once https://github.com/archspec/archspec-json/pull/57 makes it into Spack we need to rename: graviton2 -> neoverse_n1, graviton3 -> neoverse_v1

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
} || . /etc/parallelcluster/cfnconfig || {
    echo "Cannot find ParallelCluster configs"
    echo "Installing Spack into /shared/spack for ec2-user."
    cfn_ebs_shared_dirs="/shared"
    cfn_cluster_user="ec2-user"
}

install_path=${SPACK_ROOT:-"${cfn_ebs_shared_dirs}/spack"}

setup_spack() {
    cd "${install_path}"

    # Load spack at login
    if [ -z "${SPACK_ROOT}" ]
    then
        echo ". ${install_path}/share/spack/setup-env.sh" > /etc/profile.d/spack.sh
        echo ". ${install_path}/share/spack/setup-env.csh" > /etc/profile.d/spack.csh
    fi
    
}

if [ "3" != "$(major_version)" ]; then
    echo "ParallelCluster version $(major_version) not supported."
    exit 1
fi

setup_spack |& tee -a /var/log/spack-postinstall.log
