variable "region-name" {
description = "making region a variable"
default = "eu-west-2"
type = string
}

variable "cidr-for-vpc" {
description = "the cidr for vpc"
default = "10.0.0.0/16"
type = string
}

variable "cidr-for-public-sub1" {
description = "public sub1 cidr"
default = "10.0.1.0/24"
type = string
}

variable "cidr-for-public-sub2" {
description = "public sub2 cidr"
default = "10.0.2.0/24"
type = string
}

variable "cidr-for-private-sub1" {
description = "private sub1 cidr"
default = "10.0.3.0/24"
type = string
}

variable "cidr-for-private-sub2" {
description = "private sub2 cidr"
default = "10.0.4.0/24"
type = string
}
