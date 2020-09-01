#!/bin/bash

# Prompt user validation
RANDOM_NUMBER=$(shuf -i1000-9999 -n1)
INPUT_FULL="${inventory}-${RANDOM_NUMBER}"
read -p "Please confirm environment by typing ${INPUT_FULL}: " input

if [ "$input" != "$INPUT_FULL" ]
then
    echo "Validation failed!"
    exit 1
fi
