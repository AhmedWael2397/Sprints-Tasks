# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "MainVPC"
  }
}


# Create a Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

# Create a Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "PrivateSubnet"
  }
}


# Create an S3 bucket
resource "aws_s3_bucket" "sprintbuck" {
  bucket = "sprintbuck"  # S3 bucket names must be globally unique

  tags = {
    Name = "testBucket"
  }
}


# Create a Security Group for the EC2 instance
resource "aws_security_group" "ec2_security_group" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2SecurityGroup"
  }
}

# Launch an EC2 instance in the Public Subnet
resource "aws_instance" "test_server" {
  ami                         = "ami-04484aa281f291951"  # Replace with a valid AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2_security_group.id]
  key_name                    = "AWS-Access"  # Replace with your SSH key name

  tags = {
    Name = "WebServerInstance"
  }
}
