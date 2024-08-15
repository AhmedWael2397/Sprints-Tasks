provider "aws" {
  region     = "us-east-1"
}

###################### AWS ACCESS KEY-PAIR #############################
resource "aws_key_pair" "my_keypair" {
  key_name   = "AWS-Access"
  public_key = file("~/.ssh/id_rsa.pub")
}