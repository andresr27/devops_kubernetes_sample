output "instance_ips" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2-bastion.instance_ips
}