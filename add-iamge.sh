#!/usr/bin/env bash

IMG=$1

if ! [ -f $IMG ]; then
    echo "Please specify a path to an image"
    exit
fi

PATHFULL=assets/images/full
PATH420=assets/images/420

mkdir -p $PATHFULL $PATH420

file=$(basename $IMG)

convert $IMG -resize 420x420 "${PATH420}/${file%.*}.png"
convert $IMG "${PATHFULL}/${file%.*}.png"
