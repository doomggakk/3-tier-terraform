output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.vpc.id, "")
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.vpc.arn, "")
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.vpc.cidr_block, "")
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = compact(aws_subnet.subnet-pri[*].cidr_block)
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.subnet-pri[*].id
}

output "private_subnet_a_cidr_block" {
  description = "private subnet az-a cidr block"
  value = aws_subnet.subnet-pri[0].cidr_block
}

output "private_subnet_c_cidr_block" {
  description = "private subnet az-c cidr block"
  value = aws_subnet.subnet-pri[2].cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.subnet-pub[*].id
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = compact(aws_subnet.subnet-pub[*].cidr_block)
}

output "db_subnets" {
  description = "List of IDs of db subnets"
  value       = aws_subnet.subnet-db[*].id
}

output "db_subnets_cidr_blocks" {
  description = "List of cidr_blocks of db subnets"
  value       = compact(aws_subnet.subnet-db[*].cidr_block)
}



