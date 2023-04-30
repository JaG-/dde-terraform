# Network
vpc_cidr           = "10.11.0.0/16"
public_subnet_cidr = "10.11.1.0/24"

# Windows Virtual Machine
windows_instance_name               = "octopus server"
windows_instance_type               = "t3a.medium"
windows_associate_public_ip_address = true
windows_root_volume_size            = 50
windows_root_volume_type            = "gp2"
windows_data_volume_size            = 50
windows_data_volume_type            = "gp2"