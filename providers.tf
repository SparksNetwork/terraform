provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  alias = "east"
  region = "us-east-1"
}

