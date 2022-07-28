resource "aws_instance" "utility_instance" {
	# checkov:skip=CKV_AWS_88: Public jump box
  ami           = "ami-042e8287309f5df03"
  instance_type = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ssm_mgr_policy.name
  monitoring = true

  tags = {
    Name = "Utility Instance"
    Defender = "false"
  }
}

resource "aws_instance" "web_instance" {
	# checkov:skip=CKV_AWS_88: Public Access Web Server
  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id, aws_security_group.allow_http.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ssm_mgr_policy.name
  monitoring = true

  tags = {
    Name = "Web Instance"
    Defender = "false"
  }
}

resource "aws_instance" "mysql_instance" {
  ami           = "ami-0002b455cced01717"
  instance_type = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  subnet_id = aws_subnet.public.id
  iam_instance_profile = aws_iam_instance_profile.ssm_mgr_policy.name
  monitoring = true

  tags = {
    Name = "MySQL Instance"
    Defender = "false"
  }
}