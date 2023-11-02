# VPC (Virtual Private Cloud)
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16" # Adjust the CIDR block as needed
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Public subnet
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    name = "Public Subnet1"
  }
}
resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    name = "Public Subnet2"
  }
}

# Public route table
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

# Route table association
resource "aws_route_table_association" "PublicRTassociation1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.PublicRT.id
}
resource "aws_route_table_association" "PublicRTassociation2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.PublicRT.id
}

# Internet Gateway (IGW)
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Security group
resource "aws_security_group" "my_security_group" {
    name        = "my-security-group"
    description = "Security group for SSH and HTTP"
    vpc_id      = aws_vpc.my_vpc.id

  # Ingress rule for SSH
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule for HTTP
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule for all ports
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }
}

# Instance profile IAM role
resource "aws_iam_role" "my_iam_role" {
    name = "ECR-LOGIN-AUTO"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
            Service = "ec2.amazonaws.com"
            }
        }
        ]
    })
}

# Attach policies to the IAM role
resource "aws_iam_policy_attachment" "my_iam_policy" {
    name       = "my_iam_policy"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    roles      = [aws_iam_role.my_iam_role.name]
}

# Launch Template
resource "aws_launch_template" "my_lt" {
    name = "my-launch-template"
    image_id = "ami-041feb57c611358bd"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.my_security_group.id]
    iam_instance_profile {
        name = "my-instance-profile"
    }
    user_data = base64encode(<<-EOF
        #!/bin/bash
        sudo su
        # Install Docker
        sudo amazon-linux-extras install -y docker
        sudo service docker start
        
        # Authenticate with ECR (use AWS CLI v2 for this)
        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 292672040235.dkr.ecr.us-east-1.amazonaws.com

        # Install and start AWS CodeDeploy agent
        yum install -y ruby
        cd /home/ec2-user
        aws s3 cp s3://aws-codedeploy-us-east-1/latest/install . --region us-east-1
        chmod +x ./install
        ./install auto
        service codedeploy-agent start
        
        EOF
    )
    block_device_mappings {
        # Custom block device mapping for the root volume.
        device_name = "/dev/xvda"
        ebs {
        volume_size = 20
        volume_type = "gp2"
        }
    }
}

# Auto Scaling Group (ASG)
resource "aws_autoscaling_group" "my_asg" {
    name = "my-asg"
    launch_template {
        id      = aws_launch_template.my_lt.id
        version = "$Latest"
    }
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    #availability_zones   = [var.availability_zones[0]]     #this conflicts with vpc_zone_identifier
    vpc_zone_identifier  = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
    health_check_type    = "EC2"
    default_cooldown     = 300
    target_group_arns    = [aws_lb_target_group.my_target_group.arn]

    tag {
      key                 = "DeploymentGroup"
      value               = "MyDeploymentGroup"  # Specify your deployment group name
      propagate_at_launch = true
    }
}

# Create an Application Load Balancer (ALB)
resource "aws_lb" "my_alb" {
    name               = "my-alb"
    internal           = false
    load_balancer_type = "application"
    subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
    enable_deletion_protection = false # For demo purposes
}

# Create a target group for the ALB
resource "aws_lb_target_group" "my_target_group" {
    name     = "my-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.my_vpc.id
    target_type = "instance"

    health_check {
        path                = "/"
        protocol            = "HTTP"
        port                = "traffic-port"
        interval            = 30
        timeout             = 10
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
}

# Attach ASG to the target group
resource "aws_autoscaling_attachment" "asg_attachment" {
    autoscaling_group_name = aws_autoscaling_group.my_asg.name
    alb_target_group_arn  = aws_lb_target_group.my_target_group.arn
}

