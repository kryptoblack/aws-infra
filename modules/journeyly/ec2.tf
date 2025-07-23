data "aws_ami" "amz_linux" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-arm64"]
  }

  owners = ["137112412989"] # amazon
}

resource "aws_instance" "free" {
  ami = data.aws_ami.amz_linux.id
  # ami           = "ami-08d019c28ad8d0847"
  instance_type = "t4g.small"

  network_interface {
    network_interface_id = aws_network_interface.free.id
    device_index         = 0
  }

  tags = merge(local.common_tags, {
    Name = "Free"
  })
}
