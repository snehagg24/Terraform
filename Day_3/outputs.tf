output "sshcommand" {
  value = "ssh -i <private_key> root@${ibm_is_floating_ip.fip1.address}"
}