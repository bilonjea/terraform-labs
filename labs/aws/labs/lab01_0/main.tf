provider "aws" {
    // Note: For security reasons, it's recommended to use environment variables
    // or AWS credentials file to manage your AWS access keys instead of hardcoding them in your Terraform configuration.
    region = "us-east-1"
}

resource "aws_instance" "amzonelinux" {
    ami = "ami-0fad8fde16baeeccf"
    instance_type = "t3.small"

    tags = {
      Name          = "macOS_one"
      Environnement = "formation"
      Cours         = "TFV"
  }
}

resource "aws_instance" "macos" {
    ami = "ami-0f8a61b66d1accaee"
    instance_type = "t3.micro"

    tags = {
      Name          = "macOS"
      Environnement = "formation"
      Cours         = "TFV"
  }
}

output "name" {
    value = aws_instance.amzonelinux.tags["Name"]
  
}


output "id" {
    value = aws_instance.amzonelinux.id
  
}


output "allvalue" {   
  value = {
    Name          = aws_instance.amzonelinux.tags["Name"]
    Environnement = aws_instance.amzonelinux.tags["Environnement"]
    Cours         = aws_instance.amzonelinux.tags["Cours"]
   }
}


output "macos_public_ip" {
    value = aws_instance.macos.public_ip  
}









