output "server_ip" {
  description = "Public IP of the Minecraft EC2"
  value       = aws_instance.minecraft.public_ip
}
