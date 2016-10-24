module "vpc" {
  source = "./modules/vpc"
  cidr_block = "172.17.0.0/16"
}