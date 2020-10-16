variable "algo_name" {}
variable "ssh_public_key" {}
variable "user_data" {}

variable "vpc_id"{}

variable "subnet_id"{}

variable "wireguard_network" {
  type = map(string)

  default = {
    ipv4 = "10.19.49.0/24"
    ipv6 = "fd9d:bc11:4021::/48"
    port = 51820
  }
}

variable "image" {
  default = "ubuntu-disco-19.04"
}

variable "size" {
  default = "t2.micro"
}


variable "encrypted" {
  default = true
}

variable "kms_key_id" {
  default = ""
}

variable "algo_ip" {}
