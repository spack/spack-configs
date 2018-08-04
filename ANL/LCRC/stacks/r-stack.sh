#!/usr/bin/env bash

# R Software Stack

trap 'exit' INT

# Requirements for AutoMOMML
# A machine learning pipeline developed by MCS/ALCF
packages=(
    adabag@4.1
    assertthat@0.1
    # biocinstaller@1.20.3  # exact version not available
    car@2.1-4
    caret@6.0-73
    checkpoint@0.3.15
    coin@1.1-3
    colorspace@1.3-2
    corrplot@0.77
    cubist@0.0.19
    curl@2.3
    data-table@1.10.0
    devtools@1.12.0
    dichromat@2.0-0
    digest@0.6.11
    domc@1.3.4
    doparallel@1.0.10
    e1071@1.6-7
    ellipse@0.3-8
    foreach@1.4.3
    ggplot2@2.2.1
    git2r@0.18.0
    glmnet@2.0-5
    gridbase@0.4-7
    gtable@0.2.0
    httr@1.2.1
    igraph@1.0.1
    irlba@2.1.2
    iterators@1.0.8
    jsonlite@1.2
    kernlab@0.9-25
    kknn@1.3.1
    labeling@0.3
    lazyeval@0.2.0
    lme4@1.1-12
    magrittr@1.5
    matrixmodels@0.4-1
    mda@0.4-9
    memoise@1.0.0
    mime@0.5
    minqa@1.2.4
    mlbench@2.1-1
    modelmetrics@1.1.0
    modeltools@0.2-21
    multcomp@1.4-6
    munsell@0.4.3
    mvtnorm@1.0-5
    nloptr@1.0.4
    nmf@0.20.6
    openssl@0.9.6
    pacman@0.4.1
    party@1.1-2
    pbkrtest@0.4-4
    pkgmaker@0.22
    plotrix@3.6-4
    pls@2.6-0
    plyr@1.8.4
    quantreg@5.29
    r6@2.2.0
    randomforest@4.6-12
    rcolorbrewer@1.1-2
    rcpp@0.12.9
    rcppeigen@0.3.2.9.0
    registry@0.3
    reshape2@1.4.2
    rminer@1.4.2
    rngtools@1.2.4
    rstudioapi@0.6
    sandwich@2.3-4
    scales@0.4.1
    sparsem@1.74
    stringi@1.1.2
    stringr@1.1.0
    strucchange@1.5-1
    th-data@1.0-8
    tibble@1.2
    whisker@0.3-2
    withr@1.0.2
    xgboost@0.4-4
    xtable@1.8-2
    zoo@1.7-14
)

for package in "${packages[@]}"
do
    spack install r-$package
done

for package in "${packages[@]}"
do
    spack activate r-$package
done

