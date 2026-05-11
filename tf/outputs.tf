output "lb_names" {
  description = "Names of the created load balancer VMs"
  value       = [for vm in proxmox_vm_qemu.lb : vm.name]
}

output "master_names" {
  description = "Names of the created master VMs"
  value       = [for vm in proxmox_vm_qemu.master : vm.name]
}

output "worker_names" {
  description = "Names of the created worker VMs"
  value       = [for vm in proxmox_vm_qemu.worker : vm.name]
}
