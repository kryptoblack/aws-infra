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
  # ami           = "ami-08d019c28ad8d0847"
  ami           = data.aws_ami.amz_linux.id
  instance_type = "t4g.small"

  key_name = aws_key_pair.developer_key.key_name

  tags = merge(local.common_tags, {
    Name = "Free"
  })
}

resource "aws_key_pair" "developer_key" {
  key_name   = "journeyly-developer-key"
  public_key = var.journeyly_dev_public_ssh
}
