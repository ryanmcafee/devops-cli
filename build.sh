#!/usr/bin/env bash
set -eo pipefail

ALPINE_VERSION=3.11.6
TERRAFORM_VERSION=0.12.2
AZURE_CLI_VERSION=2.5.0

for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   
    case "$KEY" in
            ALPINE_VERSION)              ALPINE_VERSION=${VALUE} ;;
            TERRAFORM_VERSION)    TERRAFORM_VERSION=${VALUE} ;;
            AZURE_CLI_VERSION)    AZURE_CLI_VERSION=${VALUE} ;;      
            *)   
    esac    
done

echo "Building devops cli image using parameters provided..."
docker build --build-arg ALPINE_VERSION="$ALPINE_VERSION" --build-arg TERRAFORM_VERSION="$TERRAFORM_VERSION" --build-arg AZURE_CLI_VERSION="$AZURE_CLI_VERSION" -t ryanmcafee/devops-cli .

echo "Completed building container!"