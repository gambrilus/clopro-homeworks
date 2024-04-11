terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone      = var.default_zone
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  token     = var.token
}

resource "yandex_vpc_network" "gambrilus" {
name = "gambrilus"
}

resource "yandex_vpc_subnet" "gambrilus" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.gambrilus.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_compute_instance" "nat_instance" {
  count = 1
  name        = "natinstance"
  resources {
    cores         = 2
    memory        = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      type        = "network-hdd"
      size        = "10"
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.gambrilus.id
    nat       = true
    ip_address = var.nat_instance_ip
  }


}

resource "yandex_compute_instance" "public" {
  count = 1
  name        = "public"
  resources {
    cores         = 2
    memory        = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd89cudngj3s2osr228p"
      type        = "network-hdd"
      size        = "10"
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.gambrilus.id
    nat       = true
  }

  metadata = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${local.server_ssh_key}"
  }
}


resource "yandex_vpc_subnet" "gambrilus_private" {
  name           = var.vpc_name_private
  zone           = var.default_zone
  network_id     = yandex_vpc_network.gambrilus.id
  v4_cidr_blocks = var.default_cidr_private
  route_table_id = yandex_vpc_route_table.net_rt.id
}

resource "yandex_vpc_route_table" "net_rt" {
  network_id = yandex_vpc_network.gambrilus.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}

resource "yandex_compute_instance" "private" {
  count = 1
  name        = "private"
  resources {
    cores         = 2
    memory        = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd89cudngj3s2osr228p"
      type        = "network-hdd"
      size        = "10"
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.gambrilus_private.id
    nat       = false
  }

  metadata = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${local.server_ssh_key}"
  }

}