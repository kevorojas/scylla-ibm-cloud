############################
# Variables
############################

variable "ibmcloud_api_key" {}
variable "region" {}
variable "ssh_key_name" {
    type = number
}
variable "node_count" {
    type = number
    default = 1
}
variable "manager_profile" {
  type    = string
  default = "cx2-2x4"
}
variable "scylla_node_profile" {
  type    = string
  default = "bx2-2x8"
  
}