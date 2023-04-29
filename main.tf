# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

data "aws_ami" "windows-2019" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_instance" "octopus-server" {
  ami           = data.aws_ami.windows-2019.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
