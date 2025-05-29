
# █░█ █ █▀█ ▀█▀ █░█ ▄▀█ █░░   █▀█ █▀█ █ █░█ ▄▀█ ▀█▀ █▀▀   █▀▀ █░░ █▀█ █░█ █▀▄ 
# ▀▄▀ █ █▀▄ ░█░ █▄█ █▀█ █▄▄   █▀▀ █▀▄ █ ▀▄▀ █▀█ ░█░ ██▄   █▄▄ █▄▄ █▄█ █▄█ █▄▀ 

# NOTE: VPC with 3 tiers spanning 3 availability zones each, for a total of 9 /20 subnets
#  Space for an additional tier and availability zone, possible total of 16 /20 subnets
#
#  Availability Zones: us-east-1a, us-east-1b, us-east-1c, <reserved>
#  Tiers: Web (public), App (private), DB (private), <reserved>
#  IPv4 only for now, can be converted to dual-stack later
#
#  For now, this architecture incurs no static cost, meaning that with no data going  
#  through the network, there will be no monthly charges.
#  This does also mean that the private subnets have no NAT and therefore no outgoing
#  internet access:
#  - Provisioning an EC2 instance doing NAT would incur compute and EBS charges
#  - Provisioning NAT gateways would each cost $20 USD per month

# Three-Tier VPC
resource "aws_vpc" "this" {
  cidr_block = "10.16.0.0/16"    # 4x4 /20 (4,096 IPs each) subnets

  # Instance Tenancy
  instance_tenancy = "default"

  # DNS
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# ------- Subnets -------

# Web Subnet A
resource "aws_subnet" "web_a" {
  vpc_id = aws_vpc.this.id

  availability_zone = "us-east-1a"
  cidr_block        = "10.16.0.0/20"

  tags = {
    Name = "main-web-a"
  }
}

# App Subnet A
resource "aws_subnet" "app_a" {
  vpc_id = aws_vpc.this.id

  availability_zone = "us-east-1a"
  cidr_block        = "10.16.16.0/20"

  tags = {
    Name = "main-app-a"
  }
}

# DB Subnet A
resource "aws_subnet" "db_a" {
  vpc_id = aws_vpc.this.id

  availability_zone = "us-east-1a"
  cidr_block        = "10.16.32.0/20"

  tags = {
    Name = "main-db-a"
  }
}

# Web Subnet B
resource "aws_subnet" "web_b" {
  vpc_id = aws_vpc.this.id

  availability_zone = "us-east-1b"
  cidr_block        = "10.16.48.0/20"

  tags = {
    Name = "main-web-b"
  }
}

# App Subnet B
resource "aws_subnet" "app_b" {
  vpc_id = aws_vpc.this.id

  availability_zone = "us-east-1b"
  cidr_block        = "10.16.64.0/20"

  tags = {
    Name = "main-app-b"
  }
}

# DB Subnet B
resource "aws_subnet" "db_b" {
  vpc_id = aws_vpc.this.id

  availability_zone = "us-east-1b"
  cidr_block        = "10.16.80.0/20"

  tags = {
    Name = "main-db-b"
  }
}

# Web Subnet C
resource "aws_subnet" "web_c" {
  vpc_id = aws_vpc.this.id

  availability_zone = "us-east-1c"
  cidr_block        = "10.16.96.0/20"

  tags = {
    Name = "main-web-c"
  }
}

# App Subnet C
resource "aws_subnet" "app_c" {
  vpc_id = aws_vpc.this.id

  availability_zone = "us-east-1c"
  cidr_block        = "10.16.112.0/20"

  tags = {
    Name = "main-app-c"
  }
}

# DB Subnet C
resource "aws_subnet" "db_c" {
  vpc_id = aws_vpc.this.id

  availability_zone = "us-east-1c"
  cidr_block        = "10.16.128.0/20"

  tags = {
    Name = "main-db-c"
  }
}

# ------- Internet Gateway -------

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "main-igw"
  }
}

# Web Subnets Route Table
resource "aws_route_table" "web" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "main-web-rt"
  }
}

# Default Gateway Route
resource "aws_route" "default_gw" {
  route_table_id         = aws_route_table.web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Route Table Association for Subnet Web A
resource "aws_route_table_association" "web_a" {
  subnet_id      = aws_subnet.web_a.id
  route_table_id = aws_route_table.web.id
}

# Route Table Association for Subnet Web B
resource "aws_route_table_association" "web_b" {
  subnet_id      = aws_subnet.web_b.id
  route_table_id = aws_route_table.web.id
}

# Route Table Association for Subnet Web C
resource "aws_route_table_association" "web_c" {
  subnet_id      = aws_subnet.web_c.id
  route_table_id = aws_route_table.web.id
}

