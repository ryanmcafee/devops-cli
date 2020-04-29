# Azure Cli, Python, Terraform, Kubectl & Helm

## Context

The cloud native software landscape, community and ecosystem is amazing. The power of cloud native software and development practices is immeasurable.  
Unfortunately, it's hard for many developers to find time to learn more about cloud native development and devops practices.    
I think there is a high barrier of entry for many and I wish to streamline and decrease that barrier by bundling common tools into a cli that you can immediately use.  
I also commonly work across multiple systems (work machine, laptop, servers, and desktop) and wanted a lightweight performant container image that bundled common cli utilities that I frequently use.    
   
I built devops-cli so I could provision/bootstrap a kubernetes cluster using terraform and then manage kubernetes app deployments with kubectl.    
I also wanted a flexible devops cli container image that would allow team members new to the world of devops to quickly get started without the need to install and setup software, paths, etc..    
If you're reading this, you're like me and want a simpler "cloud shell" that you can run locally using Docker that just works.  
Development should be fun, not difficult. Don't you agree?  
   
## What's included?

Azure Cli, Kubectl, Terraform, Helm, Python

## Usage
  
    docker run -it --rm ryanmcafee/devops-cli:latest bash

## Building

Powershell (Recommend Cross Platform Powershell Core) - https://github.com/PowerShell/PowerShell   

    ./build.ps1 -ALPINE_VERSION=3.7 -TERRAFORM_VERSION=0.12.2 -AZURE_CLI_VERSION=2.5.0  

Bash

    ./build.sh ALPINE_VERSION=3.7 TERRAFORM_VERSION=0.12.2 AZURE_CLI_VERSION=2.5.0