# declare a VPC
resource "aws_vpc" "utility" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name      = "ec2-vpc-${random_string.suffix.id}"
    yor_trace = "9ecca9cb-4e15-47c4-8868-9b81f6e3606a"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.utility.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name      = "Public Subnet"
    yor_trace = "50b21e02-5f39-44c2-aad6-d720014a2f94"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}

resource "aws_internet_gateway" "utility_igw" {
  vpc_id = aws_vpc.utility.id

  tags = {
    Name      = "utility VPC - Internet Gateway"
    yor_trace = "1093418c-abb4-4965-a5f8-a924166dad3b"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}

resource "aws_route_table" "utility_us_east_1a_public" {
  vpc_id = aws_vpc.utility.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.utility_igw.id
  }

  tags = {
    Name      = "Public Subnet Route Table"
    yor_trace = "608e4aa0-46f7-4518-9cac-8fde91e59e54"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}

resource "aws_route_table_association" "utility_us_east_1a_public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.utility_us_east_1a_public.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_sg"
  description = "Allow SSH inbound connections"
  vpc_id      = aws_vpc.utility.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "allow_ssh_sg"
    yor_trace = "5df0b814-505a-42c6-acf0-d41ada8ca583"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http_sg"
  description = "Allow HTTP inbound connections"
  vpc_id      = aws_vpc.utility.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "allow_http_sg"
    yor_trace = "03b89b1b-af65-42db-9703-82c5863658df"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}

resource "aws_security_group" "allow_outbound" {
  name        = "allow_outbound_sg"
  description = "Allow outbound connections"
  vpc_id      = aws_vpc.utility.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "allow_outbound_sg"
    yor_trace = "24377a67-0ca9-4f5a-887e-e8bc8b83bfcb"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.utility.id

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  tags = {
    yor_trace = "e2ab1c3d-2a07-49bf-a359-e0e5618a91c3"
    git_org   = "dukekautington3rd"
    git_repo  = "prisma-lab-env"
  }
}