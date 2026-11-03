resource "openstack_networking_network_v2" "formation" {
  name           = "tf-formation-net"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "formation" {
  name        = "tf-formation-subnet"
  network_id  = openstack_networking_network_v2.formation.id
  cidr        = "192.168.50.0/24"
  ip_version  = 4
  enable_dhcp = true
}

resource "openstack_compute_instance_v2" "vm" {
  name        = "tf-formation-vm"
  image_name  = var.image_name
  flavor_name = var.flavor_name

  network {
    uuid = openstack_networking_network_v2.formation.id
  }

  security_groups = ["default"]
}
