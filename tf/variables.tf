variable "proxmox_url" {
  description = "Proxmox VE API URL (e.g. https://proxmox.example.local:8006/api2/json)"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox API user (e.g. root@pam)"
  type        = string
  default     = ""
}

variable "proxmox_password" {
  description = "Proxmox API password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID (optional, use instead of user/password)"
  type        = string
  default     = ""
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret (optional, use instead of password)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "pm_tls_insecure" {
  description = "Skip TLS verification for the Proxmox API"
  type        = bool
  default     = true
}

variable "proxmox_node" {
  description = "Proxmox node name where the VMs should be created"
  type        = string
  default     = "pve"
}

variable "storage" {
  description = "Proxmox storage target for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "template_vm" {
  description = "Name of the existing Ubuntu cloud-init template VM to clone"
  type        = string
  default     = "ubuntu-template"
}

variable "cloud_init_user" {
  description = "Cloud-init username created on each VM"
  type        = string
  default     = "ubuntu"
}

variable "cloud_init_password" {
  description = "Cloud-init password for the created VMs (optional, SSH key preferred)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ssh_public_key" {
  description = "SSH public key to inject via cloud-init"
  type        = string
  default     = ""
}
