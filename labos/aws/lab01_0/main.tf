provider "aws" {
    // Note: For security reasons, it's recommended to use environment variables
    // or AWS credentials file to manage your AWS access keys instead of hardcoding them in your Terraform configuration.
    #access_key = "AKIAYDOPV"
    #secret_key = "uwLrg78EzcHoAH0tBRuaU8Bt"
    region = "us-east-1"
}

resource "aws_instance" "amzonelinux" {
    ami = "ami-0236922087fa98b6e"
    instance_type = "t3.micro"

    tags = {
      Name          = "Amazon Linux 2023"
      Environnement = "formation"
      Cours         = "TFV"
  }
}

resource "aws_instance" "web" {
    ami = "ami-05cf1e9f73fbad2e2"
    instance_type = "t3.micro"

    tags = {
      Name          = "Ubuntu Server 24.04 LTS"
      Environnement = "formation"
      Cours         = "TFV"
  }
}



