
# The VPC cidr and Subnet cider

variable "cirdr-VPC-project9" {
    type = list(string)
    default = ["10.0.0.0/16","10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24"]
  
}



variable "ami_AS_ec2" {
    description = "image id for auto scalling"
    default = "ami-061ac2e015473fbe2"
  
}

variable "instance_AS" {
  description = "autscalling instance"
  default = "t2.micro"
}

variable "first_instance_EC2" {
  description = "webserver1"
  default = "ami-0ed9277fb7eb570c9"
}

variable "second_instance_EC2" {
  description = "webserver2"
  default = "ami-061ac2e015473fbe2"
}



