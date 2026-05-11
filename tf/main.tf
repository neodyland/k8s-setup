terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url            = var.proxmox_url
  pm_user               = var.proxmox_user
  pm_password           = var.proxmox_password
  pm_api_token_id       = var.proxmox_api_token_id
  pm_api_token_secret   = var.proxmox_api_token_secret
  pm_tls_insecure       = var.pm_tls_insecure
}

locals {
  starting_vmid = 800

  lb_ips      = [for i in range(2) : format("172.16.56.%d/24", 1 + i)]
  master_ips  = [for i in range(3) : format("172.16.56.%d/24", 3 + i)]
  worker_ips  = [for i in range(3) : format("172.16.56.%d/24", 6 + i)]
  worker_ext_ips = [for i in range(3) : format("43.229.16.%d/25", 140 + i)]

  lb_vmids = [for i in range(2) : local.starting_vmid + i]
  master_vmids = [for i in range(3) : local.starting_vmid + length(local.lb_ips) + i]
  worker_vmids = [for i in range(3) : local.starting_vmid + length(local.lb_ips) + length(local.master_ips) + i]
}

resource "proxmox_vm_qemu" "lb" {
  count       = 2
  vmid        = local.lb_vmids[count.index]
  name        = "k8s-v4-lb-${count.index + 1}"
  target_node = var.proxmox_node
  clone       = var.template_vm
  full_clone  = true

  memory = 2048
  cores  = 2
  sockets = 1
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot    = "scsi0"
    size    = "25G"
    storage = var.storage
    type    = "disk"
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = var.storage
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr12"
    tag    = 600
  }

  serial {
    id = 0
  }

  ciuser       = var.cloud_init_user
  sshkeys      = var.ssh_public_key
  ipconfig0    = "ip=${local.lb_ips[count.index]},gw=172.16.56.254"
  nameserver = "1.1.1.1"
}

resource "proxmox_vm_qemu" "master" {
  count       = 3
  vmid        = local.master_vmids[count.index]
  name        = "k8s-v4-master-${count.index + 1}"
  target_node = var.proxmox_node
  clone       = var.template_vm
  full_clone  = true

  memory = 4096
  cores  = 4
  sockets = 1
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot    = "scsi0"
    size    = "25G"
    storage = var.storage
    type    = "disk"
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = var.storage
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr12"
    tag    = 600
  }

  serial {
    id = 0
  }

  ciuser     = var.cloud_init_user
  sshkeys    = var.ssh_public_key
  ipconfig0  = "ip=${local.master_ips[count.index]},gw=172.16.56.254"
  nameserver = "1.1.1.1"
}

resource "proxmox_vm_qemu" "worker" {
  count       = 3
  vmid        = local.worker_vmids[count.index]
  name        = "k8s-v4-worker-${count.index + 1}"
  target_node = var.proxmox_node
  clone       = var.template_vm
  full_clone  = true

  memory = 4096
  cores  = 4
  sockets = 1
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot    = "scsi0"
    size    = "50G"
    storage = var.storage
    type    = "disk"
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = var.storage
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr12"
    tag    = 600
  }

  network {
    id     = 1
    model  = "virtio"
    bridge = "vmbr12"
    tag    = 500
  }

  serial {
    id = 0
  }

  ciuser     = var.cloud_init_user
  sshkeys    = var.ssh_public_key
  ipconfig0  = "ip=${local.worker_ips[count.index]}"
  ipconfig1  = "ip=${local.worker_ext_ips[count.index]},gw=43.229.16.254"
  nameserver = "1.1.1.1"
}
