#!/bin/bash
# Script created without any notion of error checking or anything,
# use at own risk

PREFIX=$(dirname $0)
if [[ -f ${PREFIX}/variables.sh ]]; then
    . ${PREFIX}/variables.sh
else
    echo "Please configure variables.sh"
fi

PROJECT_DIR=${BASE_DIR}/nubis-confluence

# Name of the stack, only required value here
STACK_NAME=$1

export PATH="~/nubis/nubis-builder/bin:$PATH"

if [[ -z ${STACK_NAME} ]]; then
    echo "Usage: $0 <stack name>"
    exit 1
fi

echo "Deleting cloudformation stack: ${STACK_NAME}"
aws cloudformation delete-stack --stack-name ${STACK_NAME}

echo "Deleting consul data from stack: ${STACKNAME}"
nubis-consul --stack-name ${STACKNAME} --settings ${PROJECT_DIR}/nubis/cloudformation/parameters.json delete
