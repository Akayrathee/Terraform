
provider "aws" {
  region  = "us-east-1"
}

# this is to create an EC2 instance that will have Jenkins, Terraform and AWS installed
# This will also have security group attached


# This is for the creation of the security group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_SSH"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_SSH"
  }
}

# Data source to get the default VPC ID
data "aws_vpc" "default" {
  default = true
}

# This is for the creation of the instance with a script that going to install Jenkins, Terraform and AWS
resource "aws_instance" "workstation" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t3.medium"
  security_groups = [aws_security_group.allow_ssh.name]
  # vpc_security_group_ids = ["sg-011bd9eb154836b16"]   # Here remember the security groups is not working fine, and that's why we want to use the vpc_security_group_ids
  tags = {
    Name = "Workstation"
  }
  user_data = <<EOF
#!/bin/bash
sudo apt install -y unzip
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get -y install terraform
sudo apt-get install -y awscli
sudo apt install -y openjdk-17-jre
java -version
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get -y install jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
git clone https://github.com/Akayrathee/Terraform.git
EOF
}
