#!/bin/bash

CONFIG_DIR=$HOME/.config/git-branch-switch/
BRANCES_FILE=ordered-last-used-branches

if [ ! -f "${CONFIG_DIR}${BRANCES_FILE}" ]
then
    mkdir -p "$CONFIG_DIR"
    touch "${CONFIG_DIR}${BRANCES_FILE}"
fi

branches=($(git branch | sed 's/\*/ /'))
i=0

for branch in "${branches[@]}"
do
    printf "[%2d] $branch\n" "$i"
    ((i++))
done

read input

git checkout ${branches[$input]}
