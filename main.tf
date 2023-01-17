module "dev-vpc" {
source = "./vpc"
vpc_cidr = "10.0.0.0/16"
}

module "public-subnet-z1" {
  source = "./subnet"
  vpc-id = module.dev-vpc.vpc_id
  subnet_cidr = "10.0.0.0/24"
  zone = "us-east-1a"
  subtype = "true"
}
module "private-subnet-z1" {
  source = "./subnet"
  vpc-id = module.dev-vpc.vpc_id
  subnet_cidr = "10.0.1.0/24"
  zone = "us-east-1a"
  subtype = "false"
}
module "networkconf" {
  source = "./nat-net"
  aws_vpc_id = module.dev-vpc.vpc_id
  aws_subnet-public-1 = module.public-subnet-z2.subnet_id
}
module "network-z1" {
  source = "./network"
  aws_vpc_id = module.dev-vpc.vpc_id
  aws_internet_gateway = module.networkconf.aws_internet_gateway_id
  aws_nat_gateway = module.networkconf.aws_nat_gateway_id
  aws_subnet-public-1 = module.public-subnet-z1.subnet_id
  destination_cidr_block = "0.0.0.0/0"
  aws_subnet-private-1 = module.private-subnet-z1.subnet_id
}
module "public-subnet-z2" {
  source = "./subnet"
  vpc-id = module.dev-vpc.vpc_id
  subnet_cidr = "10.0.2.0/24"
  zone = "us-east-1b"
  subtype = "true"
}
module "private-subnet-z2" {
  source = "./subnet"
  vpc-id = module.dev-vpc.vpc_id
  subnet_cidr = "10.0.3.0/24"
  zone = "us-east-1b"
  subtype = "false"
}
module "network-z2" {
  source = "./network"
  aws_vpc_id = module.dev-vpc.vpc_id
  aws_internet_gateway = module.networkconf.aws_internet_gateway_id
  aws_nat_gateway = module.networkconf.aws_nat_gateway_id
  aws_subnet-public-1 = module.public-subnet-z2.subnet_id
  destination_cidr_block = "0.0.0.0/0"
  aws_subnet-private-1 = module.private-subnet-z2.subnet_id
}

resource "aws_security_group" "http-allowed" {
    vpc_id = module.dev-vpc.vpc_id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "http-allowed"
    }
}
