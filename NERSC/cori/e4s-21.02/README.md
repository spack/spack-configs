# e4s 21.02

The e4s 21.02 stack is based on [E4S-Project/e4s](https://github.com/E4S-Project/e4s) using [spack.yaml](https://github.com/E4S-Project/e4s/blob/v21.02/spack.yaml) provided in the 21.02 tag release which is tuned for Cori system. Shown below are the relevant files

- [spack.yaml](https://software.nersc.gov/NERSC/e4s-2102/-/blob/main/spack.yaml): The spack.yaml in top-level folder is used for building E4S into buildcache 
- [prod/spack.yaml](https://software.nersc.gov/NERSC/e4s-2102/-/blob/main/prod/spack.yaml): This is the spack.yaml used for deployment from buildcache in the desired location.
- [.gitlab-ci.yml](https://software.nersc.gov/NERSC/e4s-2102/-/blob/main/.gitlab-ci.yml): Gitlab CI file to automate deployment using Gitlab
- [setclonepath.sh](https://software.nersc.gov/NERSC/e4s-2102/-/blob/main/setclonepath.sh): Used for cloning spack with a random 8 character suffix in `CFS/m3503` to shorten length of path during CI pipeline. This is useful when we need to add padding in order to make packages relocatable. At NERSC the gitlab pipline $CI_PROJECT_PROJECT is a long path such as `/global/cscratch1/ecp-gitlab/NERSC/e4s-2102/builds/users/siddiq90/yreSDskr/0/NERSC/e4s-2102/` which causes padding issue therefore we use this script to shorten the path.
- [site_config](https://software.nersc.gov/NERSC/e4s-2102/-/tree/main/site_config): spack configuration at *site* scope that overrides default. This helps ensure user can get necessary defaults when they use this spack instance

## Project Variables

We have defined the following Variables in Gitlab project which can be found at https://software.nersc.gov/NERSC/e4s-2102/-/settings/ci_cd 

- `BUILD_E4S`: Used for building E4S stack and pushing to buildcache. `Default: True`
- `DEPLOY_E4S`: Used for running the deployment job (`Default: False`)
- `REMOVE_BUILDCACHE`: Used for removing the buildcache directory in order to rebuild E4S from source. `Default: False`
- `SPACK_CDASH_AUTH_TOKEN`: Token used for pushing spack builds to https://cdash.spack.io
