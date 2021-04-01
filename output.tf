output "backend_api_url" {
  value = "http://${module.ec2_backend.public_ip}:3030"
}

output "backend_az" {
  value = module.ec2_backend.availability_zone
}

output "backend_ip" {
  value = module.ec2_backend.public_ip
}
