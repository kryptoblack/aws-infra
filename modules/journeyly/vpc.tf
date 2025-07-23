resource "aws_vpc" "main" {
  instance_tenancy                     = "default"
  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  assign_generated_ipv6_cidr_block     = true
  enable_network_address_usage_metrics = true

  tags = merge(local.common_tags, {
    Name = "journeyly-vpc"
  })
}
