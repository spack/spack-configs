# e4s 21.05

The e4s 21.05 stack is based on [E4S-Project/e4s](https://github.com/E4S-Project/e4s) using [spack.yaml](https://github.com/E4S-Project/e4s/blob/v21.05/spack.yaml) provided in the 21.05 tag release which is tuned for Arcticus nodes in the ANL JLSE. Shown below are the relevant files:

- [spack.yaml]: The spack.yaml in top-level folder is used for building E4S to populate the buildcache in the named mirror.
- [prod/spack.yaml]: This is the spack.yaml used for deployment of E4S from the generated buildcache to the desired location.
- [.gitlab-ci.yml]: Gitlab CI file to automate deployment using Gitlab
- [setclonepath.sh]: Used for cloning spack with a random 8 character suffix in `CFS/m3503` to shorten the length of the path during the CI pipeline. This is useful when we need to add padding in order to make packages relocatable. At NERSC, e.g., the gitlab pipline $CI_PROJECT_PROJECT is a long path such as `/global/cscratch1/ecp-gitlab/NERSC/e4s-2102/builds/users/siddiq90/yreSDskr/0/NERSC/e4s-2102/` which causes padding issue therefore we use this script to shorten the path.
- [site_config]: spack configuration at *site* scope that overrides default. This helps ensure user can get necessary defaults when they use this spack instance

## Project Variables

The following variables are defined for consumption by the Gitlab project which used to install and populate the buildcache, and can be used to alter the behavior of the CI job. 

- `BUILD_E4S`: Used for building E4S stack and pushing to buildcache. `Default: True`
- `DEPLOY_E4S`: Used for running the deployment job (`Default: False`)
- `REMOVE_BUILDCACHE`: Used for removing the buildcache directory in order to rebuild E4S from source. `Default: False`
- `SPACK_CDASH_AUTH_TOKEN`: Token used for pushing spack builds to https://cdash.spack.io
