# Bootstrapping PowerShell Script
data "template_file" "windows-userdata" {
  template = <<EOF
<powershell>
Install-Module -Name OctopusDSC

Configuration SampleConfig
{
    Import-DscResource -Module OctopusDSC

    Node "localhost"
    {
        cOctopusServer OctopusServer
        {
            Ensure = "Present"
            State = "Started"

            # Server instance name. Leave it as 'OctopusServer' unless you have more than one instance
            Name = "OctopusServer"

            # The url that Octopus will listen on
            WebListenPrefix = "http://localhost:80"

            SqlDbConnectionString = "Server=(local)\SQLEXPRESS;Database=Octopus;Trusted_Connection=True;"

            # The admin user to create
            OctopusAdminUsername = "admin"
            OctopusAdminPassword = "P@ssw0rd"

            # optional parameters
            AllowUpgradeCheck = $true
            AllowCollectionOfAnonymousUsageStatistics = $true
            ForceSSL = $false
            ListenPort = 10943
            DownloadUrl = "https://octopus.com/downloads/latest/WindowsX64/OctopusServer"
        }
    }
}

# Execute the configuration above to create a mof file
SampleConfig

# Run the configuration
Start-DscConfiguration -Path ".\SampleConfig" -Verbose -wait

# Test the configuration ran successfully
Test-DscConfiguration
</powershell>
EOF
}

# Create Elastic IP for the EC2 instance
#resource "aws_eip" "windows-eip" {
#  vpc  = true
#  tags = {
#    Name = "octopus-server-eip"
#  }
#}

# Associate Elastic IP to Windows Server
#resource "aws_eip_association" "windows-eip-association" {
#  instance_id   = aws_instance.octopus-server.id
#  allocation_id = aws_eip.windows-eip.id
#}

data "aws_iam_instance_profile" "ssmagent" {
  name = "AmazonSSMRoleForInstancesQuickSetup"
}