#!/bin/bash

curl -L -o /tmp/terraform_1.1.5_linux_amd64.zip https://releases.hashicorp.com/terraform/1.1.5/terraform_1.1.5_linux_amd64.zip
unzip -d /usr/local/bin /tmp/terraform_1.1.5_linux_amd64.zip