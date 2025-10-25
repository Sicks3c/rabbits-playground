output "bastion_instance_id" {
  description = "Bastion instance ID"
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Bastion public IP address"
  value       = aws_eip.bastion.public_ip
}

output "bastion_security_group_id" {
  description = "Bastion security group ID"
  value       = aws_security_group.bastion.id
}

output "bastion_private_ip" {
  description = "Bastion private IP address"
  value       = aws_instance.bastion.private_ip
}
