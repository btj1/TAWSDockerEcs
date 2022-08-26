# Creating VPC here
resource "aws_vpc" "mainvpc" {

  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project_name} VPC"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.mainvpc.id
}
# Creating Public Subnets
resource "aws_subnet" "publicsubnets" {

  for_each                = var.publicsubnets
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = tolist(each.value)[1]
  availability_zone       = tolist(each.value)[2]
  map_public_ip_on_launch = true
  tags = {
    Name    = tolist(each.value)[0]
    Project = var.project_name
  }
}

# Creating Private App Subnets 
resource "aws_subnet" "appsubnets" {
  for_each                = var.appsubnets
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = tolist(each.value)[1]
  availability_zone       = tolist(each.value)[2]
  map_public_ip_on_launch = false
  tags = {
    Name    = tolist(each.value)[0]
    Project = var.project_name
  }
}

# Creating Private DB Subnets 
resource "aws_subnet" "dbsubnets" {
  for_each                = var.dbsubnets
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = tolist(each.value)[1]
  availability_zone       = tolist(each.value)[2]
  map_public_ip_on_launch = false
  tags = {
    Name    = tolist(each.value)[0]
    Project = var.project_name
  }
}

# Creating RT for Public Subnets and association 
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "PublicRTassociation" {
  for_each       = aws_subnet.publicsubnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.PublicRT.id
}

### Create EIP per availability Zone
resource "aws_eip" "natips" {
  for_each = aws_subnet.publicsubnets
  vpc   = true
}

resource "aws_nat_gateway" "NATgws" {
  for_each      = aws_subnet.publicsubnets
  subnet_id     = each.value.id
  allocation_id = aws_eip.natips[each.key].id
}

# Creating RT and associations for Private Application and DB Subnets
# We use Nr of App Subnets to determine how many RTs are needed

resource "aws_route_table" "PrivateRTs" {
  for_each  = aws_subnet.appsubnets
  vpc_id    = aws_vpc.mainvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgws[each.key].id
  }
}

resource "aws_route_table_association" "PrivateRTassociationapp" {
  for_each       = aws_subnet.appsubnets
  subnet_id      = aws_subnet.appsubnets[each.key].id
  route_table_id = aws_route_table.PrivateRTs[each.key].id
}

resource "aws_route_table_association" "PrivateRTassociationdb" {
  for_each       = aws_subnet.dbsubnets
  subnet_id      = aws_subnet.dbsubnets[each.key].id
  route_table_id = aws_route_table.PrivateRTs[each.key].id
}

