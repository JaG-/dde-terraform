# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

data "aws_ami" "sql-windows-2019" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-SQL_2019_Express*"]
  }

  owners = ["801119661308"] # Canonical
}

resource "aws_instance" "octopus-server" {
  ami           = data.aws_ami.sql-windows-2019.id
  instance_type = var.windows_instance_type
  subnet_id = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.aws-windows-sg.id]
  source_dest_check = false
  key_name = aws_key_pair.key_pair.key_name
  user_data = data.template_file.windows-userdata.rendered 
  associate_public_ip_address = var.windows_associate_public_ip_address
  iam_instance_profile = data.aws_iam_instance_profile.ssmagent.name
  
  # root disk
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }  # extra disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.windows_data_volume_size
    volume_type           = var.windows_data_volume_type
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = var.windows_instance_name
  }
}
