resource "aws_network_interface" "free" {
  description        = "ENI for free instance (IPv6 only)"
  subnet_id          = aws_subnet.public["a"].id
  ipv6_address_count = 1
  private_ips_count  = 0
  security_groups    = [aws_security_group.free.id]
  source_dest_check  = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-free-eni"
  })
}
