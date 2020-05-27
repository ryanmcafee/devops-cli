ARG ALPINE_VERSION=3.11.6
ARG AZURE_CLI_VERSION=2.5.1

# Build Terraform
FROM alpine:${ALPINE_VERSION} as terraform
WORKDIR /tmp
ARG TERRAFORM_VERSION=0.12.24
RUN apk add --no-cache ca-certificates bash-completion gnupg curl unzip
ADD https://keybase.io/hashicorp/pgp_keys.asc hashicorp.asc
RUN gpg --import hashicorp.asc
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig
RUN echo "terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS"
RUN gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN grep terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS | sha256sum -c -
RUN unzip -j terraform_${TERRAFORM_VERSION}_linux_amd64.zip

#Add Digital Ocean Cli Support
FROM digitalocean/doctl:latest as digitalocean

# Install Azure Cli, kubectl, helm, bash-completion, git, python, make and gcc
FROM mcr.microsoft.com/azure-cli:${AZURE_CLI_VERSION}
# Install dependencies needed for subsequent steps and common utilities needed by users of image
RUN apk add --no-cache \
    bash-completion \
    openssh-client \
    git \
    python3 \
    python3-dev \
    make \
    gcc \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs \
    curl

#Installing Powershell
# See: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache lttng-ust
# Download the powershell '.tar.gz' archive
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.0.1/powershell-7.0.1-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz
# Create the target folder where powershell will be placed
RUN mkdir -p /opt/microsoft/powershell/7
# Expand powershell to the target folder
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
# Set execute permissions
RUN chmod +x /opt/microsoft/powershell/7/pwsh
# Create the symbolic link that points to pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /bin/pwsh


# Bash shell auto completion support
RUN echo -e "\n source /usr/share/bash-completion/bash_completion" >> ~/.bashrc

RUN which kubectl || az aks install-cli
RUN test -f /usr/share/bash-completion/completions/kubectl || kubectl completion bash > /usr/share/bash-completion/completions/kubectl
RUN which helm || curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash
RUN test -f /usr/share/bash-completion/completions/helm || helm completion bash > /usr/share/bash-completion/completions/helm
COPY --from=terraform /tmp/terraform /usr/bin/terraform
COPY --from=digitalocean /app/doctl /usr/bin/doctl
WORKDIR /workspace
CMD ["bash"]