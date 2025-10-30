terraform {
  required_providers {
    ansible = {
      source = "ansible/ansible"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

variable "key_name" {}
variable "ssh_security_group" {}
variable "http_security_group" {}
variable "https_security_group" {}
variable "leet_security_group" {}
variable "testHttp_security_group" {}

# Create redmine ec2 instance
resource "aws_instance" "redmine" {
  ami = "ami-0aafdae616ee7c9b7"
  instance_type = "t2.micro"
  tags = {
    Name = "redmine"
    Service = "ticketingSoftware"
  }
  key_name = var.key_name
  root_block_device {
    volume_size = 10
  }
  security_groups = [var.ssh_security_group, var.http_security_group, var.testHttp_security_group, "default"]
}

# Add created ec2 instance to ansible inventory
resource "ansible_host" "redmine" {
  name   = aws_instance.redmine.public_ip
  groups = ["redmine"]
  variables = {
    ansible_user                 = "admin",
    ansible_ssh_private_key_file = "/opt/keys/fakeCorp.pem",
    ansible_python_interpreter   = "/usr/bin/python3",
  }
}

# Ansible playbook terraform resource sucks so here you go
resource "null_resource" "redminePlaybook" {
  depends_on = [aws_instance.redmine, ansible_host.redmine]

  provisioner "local-exec" {
    command = "sleep 15 && ansible-playbook -i ./inventory.yml --extra-vars \"@vars.yml\" ./developer/redmine.yml"
  }
}

# Create forgejo ec2 instance
resource "aws_instance" "forgejo" {
  ami = "ami-0aafdae616ee7c9b7"
  instance_type = "t2.micro"
  tags = {
    Name = "forgejo"
    Service = "Git"
  }
  key_name = var.key_name
  root_block_device {
    volume_size = 10
  }
  security_groups = [var.ssh_security_group, var.testHttp_security_group, var.leet_security_group, "default"]
}

# Add created ec2 instance to ansible inventory
resource "ansible_host" "forgejo" {
  name   = aws_instance.forgejo.public_ip
  groups = ["forgejo"]
  variables = {
    ansible_user                 = "admin",
    ansible_ssh_private_key_file = "/opt/keys/fakeCorp.pem",
    ansible_python_interpreter   = "/usr/bin/python3",
  }
}

# Ansible playbook terraform resource sucks so here you go
resource "null_resource" "forgejoPlaybook" {
  depends_on = [aws_instance.forgejo, ansible_host.forgejo]

  provisioner "local-exec" {
    command = "sleep 15 && ansible-playbook -i ./inventory.yml --extra-vars \"@vars.yml\" ./developer/forgejo.yml"
  }
}