provider "aws" {
    // Note: For security reasons, it's recommended to use environment variables
    // or AWS credentials file to manage your AWS access keys instead of hardcoding them in your Terraform configuration.
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









