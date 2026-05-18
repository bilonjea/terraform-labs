provider "aws" {
    region = var.region
}

resource "aws_instance" "example" {
  ami           = lookup(var.ami_ids, terraform.workspace, "ami-05cf1e9f73fbad2e2")
  instance_type = lookup(var.instance_types, terraform.workspace, "t3.micro")

  tags = {
    Name = "${terraform.workspace}-instance"
    Environnement = terraform.workspace
  }
  
}