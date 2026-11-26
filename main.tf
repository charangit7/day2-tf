data "aws_availability_zones" "az" {
  state = "available"
}

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# 1. VPC + 2 Subnets
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = var.vpc_name }
}

resource "aws_subnet" "s1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.az.names[0]
}

resource "aws_subnet" "s2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.az.names[1]
}

# 2. 3 EC2 Instances (char-1, char-2, char-3)
resource "aws_instance" "ec2" {
  count         = length(var.ec2_names)
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.s1.id
  tags          = { Name = var.ec2_names[count.index] }
}

# 3. 1 RDS Instance (charan-rd)
resource "aws_db_subnet_group" "db_sub" {
  name       = "${var.rds_name}-sub"
  subnet_ids = [aws_subnet.s1.id, aws_subnet.s2.id]
}

resource "aws_db_instance" "rds" {
  identifier           = var.rds_name
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = "adminuser"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_sub.name
  skip_final_snapshot  = true
  tags                 = { Name = var.rds_name }
}

# 4. 1 S3 Bucket (charan-s3)
resource "random_id" "id" {
  byte_length = 3
}

resource "aws_s3_bucket" "s3" {
  bucket = "${var.s3_prefix}-${random_id.id.hex}"
  tags   = { Name = var.s3_prefix }
}