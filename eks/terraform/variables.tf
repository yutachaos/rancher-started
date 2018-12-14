variable "aws_region" {
  default = "us-west-2"
}

variable "vpc_id" {}

variable "subnet_id_01" {}

variable "subnet_id_02" {}

variable "instance_type" {}

variable "spot_price" {}

variable "asg_desired_capacity" {}

variable "asg_max_size" {}

variable "asg_min_size" {}
