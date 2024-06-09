resource "aws_vpc" "tnc_vpc" {
  cidr_block = "10.0.0.0/27"

  tags = {
    Name = "tnc_vpc"
  }
}

resource "aws_internet_gateway" "tnc_igw" {
  vpc_id = aws_vpc.tnc_vpc.id

  tags = {
    Name = "tnc_igw"
  }
}

resource "aws_route_table" "tnc_route_table" {
  vpc_id = aws_vpc.tnc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tnc_igw.id
  }

  tags = {
    Name = "tnc_route_table"
  }
}

resource "aws_subnet" "tnc_subnet1" {
  vpc_id            = aws_vpc.tnc_vpc.id
  cidr_block        = "10.0.0.0/28"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tnc_subnet1"
  }
}

resource "aws_subnet" "tnc_subnet2" {
  vpc_id            = aws_vpc.tnc_vpc.id
  cidr_block        = "10.0.0.16/28"
  availability_zone = "us-west-2b"

  tags = {
    Name = "tnc_subnet2"
  }
}

resource "aws_route_table_association" "tnc_subnet1_assoc" {
  subnet_id      = aws_subnet.tnc_subnet1.id
  route_table_id = aws_route_table.tnc_route_table.id
}

resource "aws_route_table_association" "tnc_subnet2_assoc" {
  subnet_id      = aws_subnet.tnc_subnet2.id
  route_table_id = aws_route_table.tnc_route_table.id
}
