module "dispatch" {
  source = "./modules/dispatch"
  aws_region = "${var.aws_region}"
  subnet_ids = ["${module.vpc.public_subnet_ids}"]
}