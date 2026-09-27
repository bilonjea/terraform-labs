variable "region" {
  default = "us-east-1"
}

variable "ami_ids" {
  description = "values of AMI IDs for each environment"
  type = map(string)
  default = {
    "dev"  = "ami-05cf1e9f73fbad2e2" # ami pour dev t3.micro
    "staging"  = "ami-05cf1e9f73fbad2e2" # ami pour staging t3.micro
    "prod" = "ami-05cf1e9f73fbad2e2" # ami pour prod t3.micro
  }
}

variable "instance_types" {
  description = "values of instance types for each environment"
  type = map(string)
  default = {
    "dev"  = "t3.micro" # instance type pour dev
    "staging"  = "t3.micro" # instance type pour staging t3.milarge
    "prod" = "t3.micro" # instance type pour prod t3a.medium
  }
}
