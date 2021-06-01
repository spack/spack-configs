### How To Install on NERSC Cori

1. Choose one of the example environments in this directory and rename it to `spack.yaml`
  * To use the GCC 9.3.0 environment
    ```
    $> cp gcc-spack.yaml spack.yaml
    ```
  * To use the Intel 19.1.3.304 environment
    ```
    $> cp intel-spack.yaml spack.yaml
    ```

2. Run `install.sh`

```
$> ./install.sh
```
