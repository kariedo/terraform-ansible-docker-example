##Setup variables

variable "do_token" {}
variable "image" {}
variable "size" {}
variable "region" {}
variable "ssh_fingerprint" {}
variable "home_ipv4_addr" {}

provider "digitalocean" {
    token = var.do_token
}
 
resource "digitalocean_droplet" "docker" {
    name  = "docker"
    image = var.image
    region = var.region
    size   = var.size
    monitoring = true
    ipv6 = true
    ssh_keys = [
        var.ssh_fingerprint
    ]
}

data "http" "cloudflare_ipv4" {
  url = "https://www.cloudflare.com/ips-v4"
}

resource "digitalocean_firewall" "docker" {
  name = "docker-whitelisthome-and-cloudflare"

  droplet_ids = [digitalocean_droplet.docker.id]
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [var.home_ipv4_addr]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = flatten(["${split("\n",trimspace(data.http.cloudflare_ipv4.body))}"])
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = [var.home_ipv4_addr]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = [var.home_ipv4_addr]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = [var.home_ipv4_addr]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}

output "ip" {
    value = "${digitalocean_droplet.docker.ipv4_address}"
}