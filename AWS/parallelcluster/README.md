# About Spack Configs for AWS ParallelCluster

This directory includes Spack configs for use with [AWS ParallelCluster](https://docs.aws.amazon.com/parallelcluster/index.html), a fully-supported and maintained open-source cluster management tool that enables R&D customers and their IT administrators to operate high-performance computing (HPC) clusters on AWS. AWS ParallelCluster uses infrastructure-as-code to help you automatically and securely provision cloud resources into elastically-scaling HPC clusters capable of running jobs at large scale.

The `postinstall.sh` script included here works with the `CustomActions` feature in AWS ParallelCluster which allows scripts to be run on head node or compute nodes as part of their provisioning lifecycle.

Read more about how to use it to install and configure Spack at the [AWS HPC Blog](https://aws.amazon.com/blogs/hpc/) article [Install optimized software with Spack configs for AWS ParallelCluster](https://aws.amazon.com/blogs/hpc/install-optimized-software-with-spack-configs-for-aws-parallelcluster/).
