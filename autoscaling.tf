# --------------------------------------------------------------
# Autoscaling Group
# --------------------------------------------------------------
module "web" {

  source  = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "web-autoscaling"

  vpc_zone_identifier = module.vpc.private_subnets
  min_size            = 1
  max_size            = 2
  desired_capacity    = 2

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  tags = local.tags
}

module "was" {

  source  = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "was-autoscaling"

  vpc_zone_identifier = module.vpc.private_subnets
  min_size            = 1
  max_size            = 2
  desired_capacity    = 2

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  tags = local.tags
}




# --------------------------------------------------------------
# Autoscaling LB
# --------------------------------------------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = ""

  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_iam_instance_profile" "ssm" {
  name = "complete-asg"
  role = aws_iam_role.ssm.name
  tags = local.tags
}

resource "aws_iam_role" "ssm" {
  name = "complete-asg"
  tags = local.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

module "alb_http_sg" {
  source = "./module/security-group"

  name        = "web-alb-http"
  description = "web-alb-http"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Managed = "Terraform"
    Name = "web-alb-http"
  }
  security_group_rules = {
    ingress = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    },
    ingress = {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    },

    egress_tcp = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


}

module "alb-web" {
  source  = "terraform-aws-modules/alb/aws"

  name = "alb-web"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_http_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.certificate.arn
      target_group_index = 1
    }
  ]


  target_groups = [
    {
      name             = "web-asg-80"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    },
    {
      name             = "web-asg-443"
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
      ]
    },
  ]

  tags = local.tags
}

module "alb-was" {
  source  = "terraform-aws-modules/alb/aws"

  name = "alb-was"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_http_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.certificate.arn
      target_group_index = 1
    }
  ]


  target_groups = [
    {
      name             = "was-asg-80"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    },
    {
      name             = "was-asg-443"
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
      ]
    },
  ]
}
