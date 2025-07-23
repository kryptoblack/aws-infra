resource "aws_security_group" "free" {
  name        = "${var.name_prefix}-free"
  description = "Allow HTTPS and HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-free"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_http_ipv6" {
  description       = "Allow HTTP traffic over IPv6"
  security_group_id = aws_security_group.free.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags = merge(local.common_tags, {
    Name = "allow-http-ipv6"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_https_ipv6" {
  description       = "Allow HTTPS traffic over IPv6"
  security_group_id = aws_security_group.free.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags = merge(local.common_tags, {
    Name = "allow-https-ipv6"
  })
}
