#!/bin/bash
set -e

##############################################################################################
# # This script will configure Spack on ParallelCluster compute nodes                        #
# # Use as postinstall in AWS ParallelCluster (https://docs.aws.amazon.com/parallelcluster/) #
# # via SlurmQueues:[n]:CustomActions:OnNodeConfigured:Script                                #
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

setup_spack |& tee -a /var/log/spack-postinstall.log
