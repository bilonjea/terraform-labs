terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.45.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "nginx" {
    ami = "ami-0236922087fa98b6e"
    instance_type = "t3.micro"

    subnet_id = "subnet-0156a65859aa2a07a"
    
    #the security group is created in the VPC, 
    #so we need to specify the VPC security group ID
    #but here no need to specify the security group because it the default security group create bu AWS 
    vpc_security_group_ids = ["sg-0b90f6eeaf1466947"]

    tags = {
      Name          = "Amazon Linux 2023"
      Environnement = "formation"
      Cours         = "TFV"
  }
}

resource "aws_instance" "web" {
    ami = "ami-05cf1e9f73fbad2e2"
    instance_type = "t3.micro"
    
    subnet_id = "subnet-0156a65859aa2a07a"
    #the security group is created in the VPC, 
    #so we need to specify the VPC security group ID
    #but here no need to specify the security group because it the default security group create bu AWS 
    vpc_security_group_ids = ["sg-0b90f6eeaf1466947"]

    tags = {
      Name          = "Ubuntu Server 24.04 LTS"
      Environnement = "formation"
      Cours         = "TFV"
  }
}




