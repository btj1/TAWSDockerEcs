// Choose latest Amazon2 Linux AMI for x86_64 for Bastion Hosts 

data "aws_ami" "amaz_linux" {
  most_recent      = true
  owners           = ["amazon"]

filter {
    name   = "name"
    values = ["*amzn2-*"]
  }
filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

//Create Bastion Instances based on PublicSubnets 

resource "aws_instance" "Bastion_Instances" {
  
  for_each = var.PublicSubnet_IDs
    
  ami = data.aws_ami.amaz_linux.id
  instance_type = "t2.micro"
  subnet_id = each.value
  key_name = var.key_name
  vpc_security_group_ids = [var.BastionSG]
  
  tags = {
    Project = "var.project_name" 
    Name = "Bastion_${each.key}"
  }

}







