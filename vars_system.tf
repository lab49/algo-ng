variable "also_ssh_private" {
  default = "configs/algo_ssh.pem"
}

variable "git_source" {
  default = "https://github.com/trailofbits/algo-ng"
}

variable "ca_password" {
  description = "Specify the password for the CA key. If you are deploying algo first time, specify a strongest password. If you are updating the users, use the same password which you used to deploy Algo first time."
}
