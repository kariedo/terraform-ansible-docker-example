resource "null_resource" "ansible-create-inventory" {

  depends_on = [digitalocean_droplet.docker]

  ##Create Masters Inventory
  provisioner "local-exec" {
    command =  "echo \"[docker]\" > ansible/inventory/test"
  }
  provisioner "local-exec" {
    command =  "echo \"\n${format("%s ansible_ssh_host=%s", digitalocean_droplet.docker.name, digitalocean_droplet.docker.ipv4_address)}\" >> ansible/inventory/test"
  }
  provisioner "local-exec" {
    command =  "echo \"${format("DO Droplet: %s host public IP: %s", digitalocean_droplet.docker.name, digitalocean_droplet.docker.ipv4_address)}\" "
  }
}