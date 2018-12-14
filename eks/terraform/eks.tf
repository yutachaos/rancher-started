module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "1.8.0"
  cluster_name    = "eks-cluster"
  cluster_version = "1.10"
  vpc_id          = "${var.vpc_id}"

  subnets = [
    "${var.subnet_id_01}",
    "${var.subnet_id_02}",
  ]

  workers_group_defaults = {
    instance_type        = "${var.instance_type}"
    spot_price           = "${var.spot_price}"
    asg_desired_capacity = "${var.asg_desired_capacity}"
    asg_max_size         = "${var.asg_max_size}"
    asg_min_size         = "${var.asg_min_size}"
  }
}
