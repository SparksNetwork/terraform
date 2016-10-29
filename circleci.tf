module "circleci" {
  source = "./modules/circleci"
}

output "circleci_access_key" {
  value = "${module.circleci.access_key}"
}

output "circleci_secret_key" {
  value = "${module.circleci.secret_key}"
  sensitive = true
}