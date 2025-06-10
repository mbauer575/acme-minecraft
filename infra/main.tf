# 1. VPC
resource "aws_vpc" "minecraft" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "minecraft-vpc" }
}

# 2. Subnet
resource "aws_subnet" "minecraft" {
  vpc_id            = aws_vpc.minecraft.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = { Name = "minecraft-subnet" }
}

# 3. Internet Gateway & Route
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.minecraft.id
  tags   = { Name = "minecraft-igw" }
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.minecraft.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "minecraft-rt" }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.minecraft.id
  route_table_id = aws_route_table.r.id
}

# 4. Security Group (allow SSH + Minecraft)
resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-sg"
  description = "SSH and Minecraft port"
  vpc_id      = aws_vpc.minecraft.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "minecraft-sg" }
}

# 5. EC2 Instance
resource "aws_instance" "minecraft" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.minecraft.id
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]
  key_name               = var.ssh_key_name

  tags = { Name = "minecraft-server" }
}

# 6. Lookup a recent Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}