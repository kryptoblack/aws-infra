resource "aws_security_group" "free" {
  name        = "${local.name_prefix}-free"
  description = "Allow HTTPS and HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-free"
  })
}

### Ingress ###

resource "aws_vpc_security_group_ingress_rule" "free_allow_http_ipv6" {
  description       = "Allow HTTP ingress traffic over IPv6"
  security_group_id = aws_security_group.free.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags = merge(local.common_tags, {
    Name = "allow-http-ipv6"
  })
}

resource "aws_vpc_security_group_ingress_rule" "free_allow_https_ipv6" {
  description       = "Allow HTTPS ingress traffic over IPv6"
  security_group_id = aws_security_group.free.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags = merge(local.common_tags, {
    Name = "allow-https-ipv6"
  })
}

resource "aws_vpc_security_group_ingress_rule" "free_allow_ssh_ipv6" {
  description       = "Allow SSH ingress traffic over IPv6"
  security_group_id = aws_security_group.free.id
  cidr_ipv6         = "::/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = merge(local.common_tags, {
    Name = "allow-ssh-ipv6"
  })
}

resource "aws_vpc_security_group_ingress_rule" "free_allow_icmp_ipv6" {
  description       = "Allow ICMP ingress traffic over IPv6"
  security_group_id = aws_security_group.free.id
  cidr_ipv6         = "::/0"
  from_port         = 128
  ip_protocol       = "icmp"
  to_port           = 0
  tags = merge(local.common_tags, {
    Name = "allow-icmp-ipv6"
  })
}

### Egress ###

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  for_each = {
    free = aws_security_group.free.id
  }

  description       = "Allow all outbound traffic to IPv6"
  security_group_id = each.value
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"

  tags = merge(local.common_tags, {
    Name = "allow-all-traffic-ipv6"
  })
}
