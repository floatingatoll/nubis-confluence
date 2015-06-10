#!/bin/bash
# Script created without any notion of error checking or anything,
# use at own risk

# Assume base dir is in ~/git edit this value as needed
BASE_DIR=${HOME}/git
PROJECT_DIR=${BASE_DIR}/nubis-confluence

# Name of the stack, only required value here
STACK_NAME=$1

if [[ -z ${STACK_NAME} ]]; then
    echo "Usage: $0 <stack name>"
    exit 1
fi

aws cloudformation delete-stack ${STACK_NAME}
