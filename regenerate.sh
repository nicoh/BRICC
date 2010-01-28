#!/bin/bash

ECORE2RGEN=./ecore2rgen.rb
ECORE_MODELS="
$HOME/workspace/bcm/bcm.ecore
$HOME/workspace/bcm/typemodel.ecore"

for m in $ECORE_MODELS; do
    $ECORE2RGEN $m
done
