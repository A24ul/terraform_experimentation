provider "aws" {
  region = "ap-southeast-2"
}

variable "ami_id" {
  description = "AMI ID"
  default     = "ami-0dd60a46ecc6eac16"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
  type        = string
}

variable "instance_count" {
  description = "EC2 instance count"
  default     = 3
  type        = number
}

resource "aws_instance" "EC2_instances" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.instance_count
  key_name      = "key_pair"
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  tags = {
    Name = "EC2_Instance_${count.index+1}"
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow inbound web traffic"
#  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
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
    Name = "Security_grp"
  }
}

/*
resource "aws_vpc" "first_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Prod_vpc"
  }  
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Prod_subnet"
  }
}


resource "aws_instance" "my_second_instance" {
    ami     = "ami-0dd60a46ecc6eac16"
    instance_type = "t3.small"
   tags = {
      Name = "My_second_EC2_with_terraform"
    }
}

*/