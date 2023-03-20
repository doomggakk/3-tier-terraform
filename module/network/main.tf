locals {
  create = var.create
}

# --------------------------------------------------------------
# VPC
# --------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    "Name" = "${var.project-pre-code}-VPC"
  }
}



# --------------------------------------------------------------
# Subnet
# --------------------------------------------------------------
resource "aws_subnet" "subnet-pri" {
  count                   = var.create_subnets_pri ? length(var.subnets_pri) : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnets_pri[count.index].cidr
  availability_zone       = var.subnets_pri[count.index].az
  map_public_ip_on_launch = var.subnets_pri[count.index].map_public_ip_on_launch

  tags = {
    "Name" = "${var.project-pre-code}-Subnet-${var.subnets_pri[count.index].name_code}"
  }
}

resource "aws_subnet" "subnet-pub" {
  count                   = var.create_subnets_pub ? length(var.subnets_pub) : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnets_pub[count.index].cidr
  availability_zone       = var.subnets_pub[count.index].az
  map_public_ip_on_launch = var.subnets_pub[count.index].map_public_ip_on_launch

  tags = {
    "Name" = "${var.project-pre-code}-Subnet-${var.subnets_pub[count.index].name_code}"
  }
}

resource "aws_subnet" "subnet-db" {
  count                   = var.create_subnets_db ? length(var.subnets_db) : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnets_db[count.index].cidr
  availability_zone       = var.subnets_db[count.index].az
  map_public_ip_on_launch = var.subnets_db[count.index].map_public_ip_on_launch

  tags = {
    "Name" = "${var.project-pre-code}-Subnet-${var.subnets_db[count.index].name_code}"
  }
}






# --------------------------------------------------------------
# Route Table
# --------------------------------------------------------------
resource "aws_route_table" "rtb-pri" {
  count  = local.create && var.create_rtb_pri ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.project-pre-code}-RTB-pri"
  }
}

resource "aws_route_table_association" "pri-rt-assoc-sbn" {
  count          = local.create && var.create_rtb_pri ? length(aws_subnet.subnet-pri) : 0
  route_table_id = aws_route_table.rtb-pri[0].id
  subnet_id      = aws_subnet.subnet-pri[count.index].id

  depends_on = [aws_subnet.subnet-pri, aws_route_table.rtb-pri]
}

resource "aws_route" "rt-pri" {
  count          = local.create && var.create_rtb_pri ? length(var.rtb_route_pri) : 0
  route_table_id = aws_route_table.rtb-pri[0].id

  destination_cidr_block      = var.rtb_route_pri[count.index].destination_cidr_block
  destination_ipv6_cidr_block = var.rtb_route_pri[count.index].destination_ipv6_cidr_block
  destination_prefix_list_id  = var.rtb_route_pri[count.index].destination_prefix_list_id

  carrier_gateway_id        = var.rtb_route_pri[count.index].carrier_gateway_id
  core_network_arn          = var.rtb_route_pri[count.index].core_network_arn
  egress_only_gateway_id    = var.rtb_route_pri[count.index].egress_only_gateway_id
  gateway_id                = var.rtb_route_pri[count.index].gateway_id
  instance_id               = var.rtb_route_pri[count.index].instance_id
  nat_gateway_id            = var.rtb_route_pri[count.index].nat_gateway_id
  local_gateway_id          = var.rtb_route_pri[count.index].local_gateway_id
  network_interface_id      = var.rtb_route_pri[count.index].network_interface_id
  transit_gateway_id        = var.rtb_route_pri[count.index].transit_gateway_id
  vpc_endpoint_id           = var.rtb_route_pri[count.index].vpc_endpoint_id
  vpc_peering_connection_id = var.rtb_route_pri[count.index].vpc_peering_connection_id

  depends_on = [aws_route_table.rtb-pri]
}



resource "aws_route_table" "rtb-pub" {
  count  = local.create && var.create_rtb_pub ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.project-pre-code}-RTB-pub"
  }
}

resource "aws_route_table_association" "pub-rt-assoc-sbn" {
  count          = local.create && var.create_rtb_pub ? length(aws_subnet.subnet-pub) : 0
  route_table_id = aws_route_table.rtb-pub[0].id
  subnet_id      = aws_subnet.subnet-pub[count.index].id

  depends_on = [aws_subnet.subnet-pub, aws_route_table.rtb-pub]
}

resource "aws_route" "rt-pub" {
  count          = local.create && var.create_rtb_pub ? length(var.rtb_route_pub) : 0
  route_table_id = aws_route_table.rtb-pub[0].id

  destination_cidr_block      = var.rtb_route_pub[count.index].destination_cidr_block
  destination_ipv6_cidr_block = var.rtb_route_pub[count.index].destination_ipv6_cidr_block
  destination_prefix_list_id  = var.rtb_route_pub[count.index].destination_prefix_list_id

  carrier_gateway_id        = var.rtb_route_pub[count.index].carrier_gateway_id
  core_network_arn          = var.rtb_route_pub[count.index].core_network_arn
  egress_only_gateway_id    = var.rtb_route_pub[count.index].egress_only_gateway_id
  gateway_id                = var.rtb_route_pub[count.index].gateway_id
  instance_id               = var.rtb_route_pub[count.index].instance_id
  nat_gateway_id            = var.rtb_route_pub[count.index].nat_gateway_id
  local_gateway_id          = var.rtb_route_pub[count.index].local_gateway_id
  network_interface_id      = var.rtb_route_pub[count.index].network_interface_id
  transit_gateway_id        = var.rtb_route_pub[count.index].transit_gateway_id
  vpc_endpoint_id           = var.rtb_route_pub[count.index].vpc_endpoint_id
  vpc_peering_connection_id = var.rtb_route_pub[count.index].vpc_peering_connection_id

  depends_on = [aws_route_table.rtb-pub]
}


resource "aws_route_table" "rtb-db" {
  count  = local.create && var.create_rtb_db ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.project-pre-code}-RTB-db"
  }
}

resource "aws_route_table_association" "db-rt-assoc-sbn" {
  count          = local.create && var.create_rtb_db ? length(aws_subnet.subnet-db) : 0
  route_table_id = aws_route_table.rtb-db[0].id
  subnet_id      = aws_subnet.subnet-db[count.index].id

  depends_on = [aws_subnet.subnet-db, aws_route_table.rtb-db]
}

resource "aws_route" "rt-db" {
  count          = local.create && var.create_rtb_db ? length(var.rtb_route_db) : 0
  route_table_id = aws_route_table.rtb-db[0].id

  destination_cidr_block      = var.rtb_route_db[count.index].destination_cidr_block
  destination_ipv6_cidr_block = var.rtb_route_db[count.index].destination_ipv6_cidr_block
  destination_prefix_list_id  = var.rtb_route_db[count.index].destination_prefix_list_id

  carrier_gateway_id        = var.rtb_route_db[count.index].carrier_gateway_id
  core_network_arn          = var.rtb_route_db[count.index].core_network_arn
  egress_only_gateway_id    = var.rtb_route_db[count.index].egress_only_gateway_id
  gateway_id                = var.rtb_route_db[count.index].gateway_id
  instance_id               = var.rtb_route_db[count.index].instance_id
  nat_gateway_id            = var.rtb_route_db[count.index].nat_gateway_id
  local_gateway_id          = var.rtb_route_db[count.index].local_gateway_id
  network_interface_id      = var.rtb_route_db[count.index].network_interface_id
  transit_gateway_id        = var.rtb_route_db[count.index].transit_gateway_id
  vpc_endpoint_id           = var.rtb_route_db[count.index].vpc_endpoint_id
  vpc_peering_connection_id = var.rtb_route_db[count.index].vpc_peering_connection_id

  depends_on = [aws_route_table.rtb-db]
}



# --------------------------------------------------------------
# Internet Gateway
# --------------------------------------------------------------
resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project-pre-code}-IGW"
  }
}

/*
# --------------------------------------------------------------
# VPC Endpoint
# --------------------------------------------------------------
resource "aws_vpc_endpoint" "s3" {
  count = local.create && var.create_vpc_endpoint ? 1 : 0
  
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.ap-northeast-2.s3"

  tags = {
    Name = "${var.project-pre-code}-S3-Endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr-api" {
  count = local.create && var.create_vpc_endpoint ? 1 : 0

  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.ap-northeast-2.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  tags = {
    Name = "${var.project-pre-code}-ECR-API-Endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr-dkr" {
  count = local.create && var.create_vpc_endpoint ? 1 : 0

  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.ap-northeast-2.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  tags = {
    Name = "${var.project-pre-code}-ECR-DKR-Endpoint"
  }
}

resource "aws_vpc_endpoint" "cloudformation" {
  count = local.create && var.create_vpc_endpoint ? 1 : 0

  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.ap-northeast-2.cloudformation"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  tags = {
    Name = "${var.project-pre-code}-CloudFormation"
  }
}

*/

