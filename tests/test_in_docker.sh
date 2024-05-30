#!/bin/bash
__doc__="
Tests this dotfiles repo in a docker environment.

Requirements:
    docker
"

outside_docker(){
    __doc__="
    Script to execute on host that will start docker and run
    the tests for this repo in a fresh docker image.
    "
    # create a variable that indicates the diretory containing this file

    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        # Fallback to reasonabl hardcoded path if not running as a script
        TEST_DPATH="$HOME/dotfiles/tests"
    else
        TEST_DPATH="$(dirname -- "${BASH_SOURCE[0]}")"
    fi
    REPO_DPATH="$(dirname -- "${TEST_DPATH}")"
    echo "TEST_DPATH = $TEST_DPATH"
    echo "REPO_DPATH = $REPO_DPATH"
    #docker pull ubuntu:20.04
    docker run \
        --volume "$TEST_DPATH:/tests" \
        --volume "$REPO_DPATH:/repo" \
        -it ubuntu:20.04 bash
    # TODO: autorun. Give option to interact if needed
    #/tests/test_in_docker.sh
}

inside_docker(){
    __doc__="
    Script to execute inside docker
    "
    # TODO: add option to test local repo or remote repo
    #REPO_URI=https://github.com/Erotemic/dotfiles.git
    REPO_URI=/repo/.git
    echo "REPO_URI = $REPO_URI"

    apt update -y
    apt install git -y
    cd ~
	git config --global --add safe.directory $REPO_URI
    git config --global --add safe.directory '*'

    git clone $REPO_URI dotfiles
    cd dotfiles
    bash ~/dotfiles/init.sh

    export HOME=/root
    mkdir "$HOME"
    rm -rf "$HOME/dotfiles"

    REPO_URI=https://github.com/Erotemic/dotfiles.git
    REPO_URI=/repo/.git
    sudo apt install git -y
    git clone "$REPO_URI" "$HOME/dotfiles"
    cd "$HOME"/dotfiles
    ./initialize

}
