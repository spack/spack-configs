# e4s 21.11

The e4s 21.11 stack is based on [E4S-Project/e4s](https://github.com/E4S-Project/e4s) using [spack.yaml](https://github.com/E4S-Project/e4s/blob/v21.11/spack.yaml) provided in the 21.11 tag release which is tuned for Arcticus nodes in the ANL JLSE. Shown below are the relevant files:

Note that this repo is set up to be CI-ready, just by copying the .gitlab-ci.yml from this directory to the base directory of the repository. The environment variable WORKING_DIR maps back to this directory.

- [${WORKING_DIR}/spack.yaml](https://github.com/spack/spack-configs/blob/main/ANL/JLSE/Arcticus/E4S-21.11/spack.yaml): The spack.yaml in WORKING_DIR is used for building E4S to populate the buildcache in the named mirror.
- [${WORKING_DIR}/prod/spack.yaml](https://github.com/spack/spack-configs/blob/main/ANL/JLSE/Arcticus/E4S-21.11/prod/spack.yaml): This is the spack.yaml used for deployment of E4S from the generated buildcache to the desired location.
- [${WORKING_DIR}/.gitlab-ci.yml](https://github.com/spack/spack-configs/blob/main/ANL/JLSE/Arcticus/E4S-21.11/.gitlab-ci.yml): Gitlab CI file to automate deployment using Gitlab. (Copy it to base directory to enable CI)
- [site_config](https://github.com/spack/spack-configs/blob/main/ANL/JLSE/Arcticus/E4S-21.11/site_config): spack configuration at *site* scope that overrides default. This helps ensure user can get necessary defaults when they use this spack instance. These yaml files are copied to the spack installation during the build and deploy stages. 

## Project Variables

The following variables are defined for consumption by the Gitlab project which is used to install and populate the buildcache, and can be used to alter the behavior of the CI job. 

- `WORKING_DIR`: Points to this directory. (`ANL/JLSE/Arcticus/E4S-21.11`)
- `BUILD_E4S`: Used for building E4S stack and pushing to buildcache. (`Default: True`)
- `DEPLOY_E4S`: Used for running the deployment job. (`Default: False`)
- `REFRESH_DEPLOYMENT`: Will purge all deployed builds. (`Default: False`)
- `RUN_E4S_TESTSUITE`: Used for running the E4S testsuite. (`Default: True`)
- `REMOVE_BUILDCACHE`: Used for removing the buildcache directory in order to force the rebuild E4S from source. (`Default: False`)
