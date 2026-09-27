locals {
    # The name of the S3 bucket to create
    bucket_name = "my-unique-bucket-name-12345"
    
    # The AWS region to deploy resources in
    aws_region = "us-east-1"
    
    # The name of the DynamoDB table to create
    dynamodb_table_name = "my-demo-table"

    # The name of the EC2 instance to create
    web_ami = "ami-0b75f821522bcff85"
}