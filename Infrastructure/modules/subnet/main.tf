################################################################################
# Public Subnets
################################################################################

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public-${var.azs[count.index]}"
      Type = "Public"
      Tier = "Public"
    }
  )
}

################################################################################
# Private Subnets
################################################################################

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-${var.azs[count.index]}"
      Type = "Private"
      Tier = "Private"
    }
  )
}

################################################################################
# Elastic IPs for NAT Gateways
################################################################################

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-eip-${var.single_nat_gateway ? "shared" : var.azs[count.index]}"
    }
  )

  depends_on = [var.internet_gateway_id]
}

################################################################################
# NAT Gateways
################################################################################

resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-nat-${var.single_nat_gateway ? "shared" : var.azs[count.index]}"
    }
  )

  depends_on = [var.internet_gateway_id]
}

################################################################################
# Route Tables - Public
################################################################################

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public-rt"
      Type = "Public"
    }
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

################################################################################
# Route Tables - Private
################################################################################

resource "aws_route_table" "private" {
  count = var.single_nat_gateway ? 1 : length(var.azs)

  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-rt-${var.single_nat_gateway ? "shared" : var.azs[count.index]}"
      Type = "Private"
    }
  )
}

resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}
