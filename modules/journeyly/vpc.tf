resource "aws_vpc" "this" {
  cidr_block                           = "10.1.0.0/16"
  instance_tenancy                     = "default"
  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  assign_generated_ipv6_cidr_block     = true
  enable_network_address_usage_metrics = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

### PRIVATE ###

resource "aws_subnet" "private" {
  for_each = {
    a = {
      ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.cidr_block_size, 4)
      az              = "a"
      type            = "private"
    }
    b = {
      ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.cidr_block_size, 5)
      az              = "b"
      type            = "private"
    }
    c = {
      ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.cidr_block_size, 6)
      az              = "c"
      type            = "private"
    }
  }

  vpc_id            = aws_vpc.this.id
  ipv6_cidr_block   = each.value.ipv6_cidr_block
  availability_zone = "${var.region}${each.value.az}"

  enable_resource_name_dns_aaaa_record_on_launch = true
  assign_ipv6_address_on_creation                = true
  ipv6_native                                    = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.value.type}-${each.value.az}"
    Type = each.value.type
  })
}

resource "aws_egress_only_internet_gateway" "main" {
  vpc_id = aws_vpc.this.id
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-eoigw"
  })
}

resource "aws_default_route_table" "private" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-rt-private"
  })
}

resource "aws_route_table_association" "private" {
  for_each = {
    a = aws_subnet.private["a"].id
    b = aws_subnet.private["b"].id
    c = aws_subnet.private["c"].id
  }

  route_table_id = aws_default_route_table.private.id
  subnet_id      = each.value
}

resource "aws_default_network_acl" "private" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id
  subnet_ids             = [for subnet in aws_subnet.private : subnet.id]

  ingress {
    protocol        = -1
    rule_no         = 600
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  egress {
    protocol        = -1
    rule_no         = 600
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-private-nacl"
  })
}

### PUBLIC ###

resource "aws_subnet" "public" {
  for_each = {
    a = {
      ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.cidr_block_size, 1)
      az              = "a"
    }
    b = {
      ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.cidr_block_size, 2)
      az              = "b"
    }
    c = {
      ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, local.cidr_block_size, 3)
      az              = "c"
    }
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  ipv6_cidr_block   = each.value.ipv6_cidr_block
  availability_zone = "${var.region}${each.value.az}"

  ipv6_native                                    = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  assign_ipv6_address_on_creation                = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-${each.value.az}"
    Type = "public"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-rt-public"
  })
}

resource "aws_route_table_association" "public" {
  for_each = {
    a = aws_subnet.public["a"].id
    b = aws_subnet.public["b"].id
    c = aws_subnet.public["c"].id
  }

  route_table_id = aws_route_table.public.id
  subnet_id      = each.value
}

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = [for subnet in aws_subnet.public : subnet.id]

  ingress {
    protocol        = -1
    rule_no         = 600
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  egress {
    protocol        = -1
    rule_no         = 600
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-nacl"
  })
}
