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

if [[ -z ${STACK_NAME} ]]; then
    echo "Usage: $0 <stack name>"
    exit 1
fi

TEMPLATE_PATH="nubis/cloudformation/main.json"
PARAMETERS_PATH="nubis/cloudformation/parameters.json"

if [[ ! -f ${PROJECT_DIR}/${TEMPLATE_PATH} ]]; then
    echo "Error: Cloudformation template does not exist"
    exit 1
fi

if [[ ! -f ${PROJECT_DIR}/${PARAMETERS_PATH} ]]; then
    echo "Error: Cloudformation parameter file does not exit"
    exit 1
fi

# Create stack here
aws cloudformation create-stack --stack-name ${STACK_NAME} --template-body file://${TEMPLATE_PATH} --parameters file://${PARAMETERS_PATH}
