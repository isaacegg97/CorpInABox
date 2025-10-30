# Add key for ssh connection
resource "aws_key_pair" "fakeCorp" {
  key_name   = "fakeCorp"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBS4NpMRWpURsiNmj0zviuLlVM/DfjjlcvLddfmRh+w"
}

# Add security group for ssh
resource "aws_security_group" "ssh" {
  name = "ssh"
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Add security group for http
resource "aws_security_group" "http" {
  name = "http"
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Add security group for https
resource "aws_security_group" "https" {
  name = "https"
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Add security group for leet
resource "aws_security_group" "leet" {
  name = "leet"
  ingress {
    description = "leet"
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Add security group for testHttp
resource "aws_security_group" "testHttp" {
  name = "testHttp"
  ingress {
    description = "testHttp"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "key_name" {
  value = aws_key_pair.fakeCorp.key_name
}

output "ssh_security_group" {
  value = aws_security_group.ssh.name
}

output "http_security_group" {
  value = aws_security_group.http.name
}

output "https_security_group" {
  value = aws_security_group.https.name
}

output "leet_security_group" {
  value = aws_security_group.leet.name
}

output "testHttp_security_group" {
  value = aws_security_group.testHttp.name
}

module "developer" {
  source = "./developer"

  key_name             = aws_key_pair.fakeCorp.key_name
  ssh_security_group   = aws_security_group.ssh.name
  http_security_group  = aws_security_group.http.name
  https_security_group = aws_security_group.https.name
  leet_security_group = aws_security_group.leet.name
  testHttp_security_group = aws_security_group.testHttp.name
}

module "services" {
  source = "./services"

  key_name             = aws_key_pair.fakeCorp.key_name
  ssh_security_group   = aws_security_group.ssh.name
  http_security_group  = aws_security_group.http.name
  https_security_group = aws_security_group.https.name
  leet_security_group = aws_security_group.leet.name
  testHttp_security_group = aws_security_group.testHttp.name
}