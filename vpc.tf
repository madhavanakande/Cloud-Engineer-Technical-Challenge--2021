# Internet VPC
resource "aws_vpc" "Uturn-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "Uturn-vpc"
  }
}

# Subnets
resource "aws_subnet" "Uturn-public-1" {
  vpc_id                  = aws_vpc.Uturn-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"

  tags = {
    Name = "Uturn-public-1"
  }
}

resource "aws_subnet" "Uturn-public-2" {
  vpc_id                  = aws_vpc.Uturn-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "Uturn-public-2"
  }
}

# Internet GW
resource "aws_internet_gateway" "Uturn-igw" {
  vpc_id = aws_vpc.Uturn-vpc.id

  tags = {
    Name = "Uturn-igw"
  }
}

# route tables
resource "aws_route_table" "Uturn-rt" {
  vpc_id = aws_vpc.Uturn-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Uturn-igw.id
  }

  tags = {
    Name = "Uturn-rt"
  }
}

# route associations public
resource "aws_route_table_association" "Uturn-rta-1" {
  subnet_id      = aws_subnet.Uturn-public-1.id
  route_table_id = aws_route_table.Uturn-rt.id
}

resource "aws_route_table_association" "Uturn-rta-2" {
  subnet_id      = aws_subnet.Uturn-public-2.id
  route_table_id = aws_route_table.Uturn-rt.id
}


