variable "image_name" {
  description = "Nom d’une image Glance disponible"
  type        = string
}

variable "flavor_name" {
  description = "Nom d’un flavor Nova disponible"
  type        = string
}

output "instance_id" {
  value = openstack_compute_instance_v2.vm.id
}
