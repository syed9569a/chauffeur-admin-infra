locals {
  name_prefix = "${var.project_name}-${var.environment}-net"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  # Derive non-overlapping subnets from VPC CIDR
  public_subnet_cidrs  = [for i in range(var.az_count) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnet_cidrs = [for i in range(var.az_count) : cidrsubnet(var.vpc_cidr, 8, i + 16)]
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${local.name_prefix}-igw" })
}

# Public subnets and route table
resource "aws_subnet" "public" {
  for_each                = { for idx, az in local.azs : idx => { az = az, cidr = local.public_subnet_cidrs[idx] } }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${local.name_prefix}-public-${each.key}"
    Tier = "public"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${local.name_prefix}-public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT in the first public subnet to save cost
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(var.tags, { Name = "${local.name_prefix}-nat-eip" })
}

resource "aws_nat_gateway" "this" {
  subnet_id     = values(aws_subnet.public)[0].id
  allocation_id = aws_eip.nat.id
  tags          = merge(var.tags, { Name = "${local.name_prefix}-nat" })
  depends_on    = [aws_internet_gateway.this]
}

# Private subnets and route tables
resource "aws_subnet" "private" {
  for_each          = { for idx, az in local.azs : idx => { az = az, cidr = local.private_subnet_cidrs[idx] } }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = merge(var.tags, {
    Name = "${local.name_prefix}-private-${each.key}"
    Tier = "private"
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${local.name_prefix}-private-rt" })
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
