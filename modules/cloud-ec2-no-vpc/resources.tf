data "aws_ami_ids" "main" {
  owners = ["099720109477"]

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd/${var.image}-amd64-server-*",
    ]
  }
}

resource "aws_security_group" "main" {
  description = "Enable SSH and IPsec"
  vpc_id      = "${var.vpc_id}"
  tags = {
    Environment = "Algo"
  }

  dynamic "ingress" {
    for_each = [
      "-1:icmp",
      "22:tcp",
      "500:udp",
      "4500:udp",
      "${var.wireguard_network["port"]}:udp"
    ]

    content {
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      from_port        = split(":", ingress.value)[0]
      to_port          = split(":", ingress.value)[0]
      protocol         = split(":", ingress.value)[1]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_key_pair" "main" {
  key_name_prefix = "algo-"
  public_key      = "${var.ssh_public_key}"
}

resource "aws_instance" "main" {
  ami                                  = data.aws_ami_ids.main.ids[0]
  instance_type                        = "${var.size}"
  instance_initiated_shutdown_behavior = "terminate"
  key_name                             = "${aws_key_pair.main.key_name}"
  vpc_security_group_ids               = ["${aws_security_group.main.id}"]
  subnet_id                            = "${var.subnet_id}"
  user_data                            = "${var.user_data}"
  ipv6_address_count                   = 1

  root_block_device {
    volume_size           = 8
    delete_on_termination = true
    encrypted             = var.encrypted
    kms_key_id            = var.kms_key_id
  }

  tags = {
    Environment = "Algo"
  }

  volume_tags = {
    Environment = "Algo"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip_association" "main" {
  instance_id   = "${aws_instance.main.id}"
  allocation_id = var.algo_ip
}
