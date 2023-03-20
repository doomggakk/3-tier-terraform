# --------------------------------------------------------------
# Network Module
# --------------------------------------------------------------

module "vpc" {
  source = "./module/network"

  project-pre-code = "DEV"

  create_subnets_pri = true
  subnets_pri = [
    {
      cidr                    = "10.106.10.0/24"
      az                      = "ap-northeast-2a"
      map_public_ip_on_launch = false
      name_code               = "A-pri"
    },
    {
      cidr                    = "10.106.11.0/24"
      az                      = "ap-northeast-2c"
      map_public_ip_on_launch = false
      name_code               = "C-pri"
    },
  ]

  create_subnets_pub = true
  subnets_pub = [
    {
      cidr                    = "10.106.8.0/25"
      az                      = "ap-northeast-2a"
      map_public_ip_on_launch = true
      name_code               = "A-pub"
    },
    {
      cidr                    = "10.106.8.128/25"
      az                      = "ap-northeast-2c"
      map_public_ip_on_launch = true
      name_code               = "C-pub"
    },
  ]


  create_rtb_pri = true
  rtb-pri = {

  }

  create_rtb_pub = true
  rtb-pub = {

  }

  create_vpc_endpoint = true

}


