variable "project_name" {
  type        = string
  default     = "liveproject_TAWS"
  description = "Name for the live_project"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region to deploy the Stack in"
}

variable "publicsubnets" {
  type = object({

    subnet1 = list(string),
    subnet2 = list(string),
    subnet3 = list(string)
  })

  default = {
    subnet1 = ["publicA", "172.16.1.0/24", "us-east-1a"],
    subnet2 = ["publicB", "172.16.2.0/24", "us-east-1b"],
    subnet3 = ["publicC", "172.16.3.0/24", "us-east-1c"]
  }
  description = "CIDRs for the public subnets, note that the nr of subnets determines the nr. of EIPs and NAT_GWs as well"
}
variable "vpc_cidr" {
  type        = string
  default     = "172.16.0.0/16"
  description = "CIDR Range to use for the VPC"
}

variable "dbsubnets" {
  type = object({

    subnet1 = list(string),
    subnet2 = list(string),
    subnet3 = list(string)
  })

  default = {
    subnet1 = ["DbA", "172.16.8.0/24", "us-east-1a"],
    subnet2 = ["DbB", "172.16.9.0/24", "us-east-1b"],
    subnet3 = ["DbC", "172.16.10.0/24", "us-east-1c"]
  }
  description = "CIDRs for the public subnets, note that the nr of subnets determines the nr. of EIPs and NAT_GWs as well"
}

variable "appsubnets" {
  type = object({

    subnet1 = list(string),
    subnet2 = list(string),
    subnet3 = list(string)
  })

  default = {
    subnet1 = ["AppA", "172.16.4.0/24", "us-east-1a"],
    subnet2 = ["AppB", "172.16.5.0/24", "us-east-1b"],
    subnet3 = ["AppC", "172.16.6.0/24", "us-east-1c"]
  }
  description = "Infos for the Appsubnets, note that the nr of subnets determines the nr. of EIPs and NAT_GWs as well"
}





