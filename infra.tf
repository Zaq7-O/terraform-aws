
module "vpc" {
  source  = "./modules/vpc"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

#####SG FOR ALB 
resource "aws_security_group" "alb-http" {
  name        = "alb-http"
  description = "alb-http"
  vpc_id      = var.vpc_name

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.env
  }
}

###ALB RESOURCE 

module "alb" {
  source = "./modules/alb"

  name = "one"

  load_balancer_type = "application"

  internal = "false"
  vpc_id      = var.vpc_name
#  vpc_id             = "vpc-abcde012"
#  subnets            = ["subnet-abcde012", "subnet-bcde012a"]
#  security_groups    = ["sg-edcd9784", "sg-edcd9785"]
   security_groups            = [aws_security_group.alb-http.id]
   subnets                    = var.vpc_public_subnets

   tags = { 
   Environment = var.env 
}

  target_groups = [
    {
      name_prefix      = "one-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

}



##SG FOR EC2

resource "aws_security_group" "prod-one" {
  name        = "prod-one"
  description = "prod-one"
  vpc_id      = var.vpc_name

  ingress {
    from_port   = 0
    to_port     = 80
    protocol    = "HTTP"
    cidr_blocks = ["10.1.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.env
  }
}

##LAUNCHING EC2 


resource "aws_instance" "prod-one" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  count                  = var.count_no
  vpc_security_group_ids = ["aws_security_group.prod-one.id"]
#  subnet_id              = var.subnet_id1
  subnet_id              = "var.vpc_private_subnets"
  key_name               = var.key_name
  tags = {
    Environment = var.env
   
  }
}


##Launch Configuration and ASG 

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "service"

  # Launch configuration
  lc_name = "one-lc"

  image_id        = var.ami_id
  instance_type   = var.instance_type
  security_groups = ["aws_security_group.prod-one.id"]
  #security_groups = ["sg-12345678"]


  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "one-asg"
  #vpc_zone_identifier       = ["subnet-1235678", "subnet-87654321"]
  vpc_zone_identifier       = ["var.vpc_private_subnets"]
  health_check_type         = "EC2"
  min_size                  = 2
  max_size                  = 3
  desired_capacity          = 2
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
  ]

  tags_as_map = {
    extra_tag1 = "extra_value1"
    extra_tag2 = "extra_value2"
  }
}



