resource "aws_instance" "utility_instance" {
  # checkov:skip=CKV_AWS_88: Public jump box
  ami                         = "ami-042e8287309f5df03"
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ssm_mgr_policy.name
  monitoring                  = true

  tags = {
    Name      = "Utility Instance"
    Defender  = "false"
    yor_trace = "e679949e-2452-4e9e-8ad7-e9db9f231ea8"
  }
}

resource "aws_instance" "web_instance" {
  ami                         = "ami-08d4ac5b634553e16"
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]

  tags = {
    Name      = "Web Instance"
    Defender  = "false"
    yor_trace = "e5f76f9c-2be5-4f44-8dad-d018a47152e5"
  }

  user_data = <<-EOF
    #!/bin/bash
    set -ex
    # install Docker runtime
    sudo apt update -y
    sudo apt install ca-certificates curl gnupg lsb-release -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    sudo usermod -aG docker ubuntu
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
    # install Defender
    sudo apt install jq -y
    AUTH_DATA="$(printf '{ "username": "%s", "password": "%s" }' "${var.PCC_ACCESS_KEY_ID}" "${var.PCC_SECRET_ACCESS_KEY}")"
    TOKEN=$(curl -sSLk -d "$AUTH_DATA" -H 'content-type: application/json' "${var.PCC_URL}/api/v1/authenticate" | jq -r ' .token ')
    DOMAINNAME=`echo ${var.PCC_URL} | cut -d'/' -f3`
    curl -sSLk -H "authorization: Bearer $TOKEN" -X POST "${var.PCC_URL}/api/v1/scripts/defender.sh" | sudo bash -s -- -c $DOMAINNAME -d "none" -m
    # setup environments for Log4Shell demo
    docker network create dirty-net
    docker container run -itd --rm --name vul-app-1 --network dirty-net fefefe8888/l4s-demo-app:1.0
    docker container run -itd --rm --name vul-app-2 --network dirty-net fefefe8888/l4s-demo-app:1.0
    docker container run -itd --rm --name att-svr --network dirty-net fefefe8888/l4s-demo-svr:1.0
    docker container run -itd --rm --network dirty-net --name attacker-machine fefefe8888/my-ubuntu:18.04
    EOF

  monitoring = true
  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  #   ebs_block_device {
  #     encrypted = true
  #   }
}

