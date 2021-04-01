data "aws_ami" "backend_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

locals {
  backend_user_data = <<EOF
#!/bin/bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install npm consul -y
sudo npm install pm2 --global
cd /home/ubuntu
mkdir backend
wget ${var.app_s3_addr}
tar -xvzf backend.tar.gz -C backend/
cd backend
cp .env.sample .env
sed -i "s/TYPEORM_HOST=mydbaddr/TYPEORM_HOST=${var.db_address}/g" .env
source .env
sudo npm i
sudo npm run build
sudo pm2 install typescript
sudo npm run migrations
sudo pm2 start src/main.ts
EOF
}

module "ec2_backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~>2.0"

  instance_count = var.backend_instance_count

  name                        = var.backend_name
  ami                         = data.aws_ami.backend_ami.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_ids                  = var.backend_subnets
  vpc_security_group_ids      = [var.security_group]
  associate_public_ip_address = true

  user_data_base64 = base64encode(local.backend_user_data)

  tags = var.tags

}
