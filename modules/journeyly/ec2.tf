# data "aws_ami" "amz_linux" {
#   most_recent = true
#
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }
#
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#
#   owners = ["099720109477"]
# }
#
# resource "aws_instance" "free" {
#   ami           = data.aws_ami.amz_linux.id
#   instance_type = "t4g.small"
#
#   tags = merge(local.common_tags, {
#     Name = "Free"
#   })
# }
