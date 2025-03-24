data "aws_availability_zones" "available" {
  # Do not include local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  name = basename(path.cwd)
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {}
}

provider "aws" {
  region = var.aws_region
}