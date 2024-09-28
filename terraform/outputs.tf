# Try to logon to the Virtual Service Instance
output "public-ip-nodes" {
  value = [for i in range(var.node_count) : "vsi${ibm_is_instance.vsi[i].name}: ${ibm_is_floating_ip.fip[i].address}"]
}

output "private-ip" {
  value = [for i in range(var.node_count): "private ip vsi${ibm_is_instance.vsi[i].name}: ${ibm_is_instance.vsi[i].primary_network_interface[0].primary_ipv4_address}"]
  # value = ibm_is_instance.vsi1.primary_network_interface[0].primary_ipv4_address
}
