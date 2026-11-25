# VPC
resource "aws_vpc" "charan_vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "${var.charan_name}-vpc" }
}

resource "aws_subnet" "charan_subnet" {
  vpc_id     = aws_vpc.charan_vpc.id
  cidr_block = "10.0.1.0/24"
  tags       = { Name = "${var.charan_name}-subnet" }
}

# EC2
resource "aws_instance" "charan_vms" {
  count         = 3
  ami           = "ami-053b12d3152c0cc71" 
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.charan_subnet.id
  tags          = { Name = "charan-vm-${count.index + 1}" }
}

# RDS
resource "aws_db_instance" "charan_db" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  db_name              = "charandata"
  username             = "admin"
  password             = var.db_pass
  skip_final_snapshot  = true
}

# S3 Bucket
resource "aws_s3_bucket" "charan_bucket" {
  bucket = "charan-storage-bucket-2026-unique" 
}
