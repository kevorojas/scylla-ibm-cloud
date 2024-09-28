terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.69.1"
    }
  }
}

#Provider
provider "ibm" {
  region           = var.region
  ibmcloud_api_key = var.ibmcloud_api_key
}

############################
# Virtual Private Cloud
############################

# Virtual Private Cloud
resource "ibm_is_vpc" "vpc-instance" {
  name = "${local.BASENAME}-vpc"
}

############################
# Security group
############################

resource "ibm_is_security_group" "sg1" {
  name = "${local.BASENAME}-sg1"
  vpc  = ibm_is_vpc.vpc-instance.id
}

############################
# Security Group Rules
############################

resource "ibm_is_security_group_rule" "allow-ssh" { 
  group     = ibm_is_security_group.sg1.id
  direction = "inbound"
  remote    = "your-ip-address" 

  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "allow-cql" {
  group     = ibm_is_security_group.sg1.id
  direction = "inbound"
  remote    = "your-ip-address"

  tcp {
    port_min = 9042
    port_max = 9042
  }
}

resource "ibm_is_security_group_rule" "allow-grafana" {
  group     = ibm_is_security_group.sg1.id
  direction = "inbound"
  remote    = "your-ip-address"

  tcp {
    port_min = 3000
    port_max = 3000
  }
}

resource "ibm_is_security_group_rule" "allo-internal-comunication" {
  group     = ibm_is_security_group.sg1.id
  direction = "inbound"
  remote    = ibm_is_subnet.subnet1.ipv4_cidr_block
}

# create outbound rule
resource "ibm_is_security_group_rule" "allow-egress-all" {
  group     = ibm_is_security_group.sg1.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

############################
# Subnet 
############################

resource "ibm_is_subnet" "subnet1" {
  name                     = "${local.BASENAME}-subnet1"
  vpc                      = ibm_is_vpc.vpc-instance.id
  zone                     = local.ZONE
  total_ipv4_address_count = 256
}

############################
# Virtual Servicer Instance
############################

# ssh key
data "ibm_is_ssh_key" "ssh_key_id" {
  name = var.ssh_key_name
}

# Image for Virtual Server Insance
data "ibm_is_image" "debian" {
  name = "ibm-debian-11-9-minimal-amd64-2"
}

# Virtual Server Insance
resource "ibm_is_instance" "vsi" {
  count   = var.node_count
  name    = "${local.BASENAME}-vsi-${count.index}"
  vpc     = ibm_is_vpc.vpc-instance.id
  keys    = [data.ibm_is_ssh_key.ssh_key_id.id]
  zone    = local.ZONE
  image   = data.ibm_is_image.debian.id
  profile = var.scylla_node_profile

  # References to the subnet and security groups
  primary_network_interface {
    subnet          = ibm_is_subnet.subnet1.id
    security_groups = [ibm_is_security_group.sg1.id]
  }
}

# Request a foaling ip 
resource "ibm_is_floating_ip" "fip" {
  count  = var.node_count
  name   = "${local.BASENAME}-fip-${count.index}"
  target = ibm_is_instance.vsi[count.index].primary_network_interface[0].id
}


##########################
# Scylladb Manager
##########################

resource "ibm_is_instance" "vsi-Manager" {
  name    = "${local.BASENAME}-manager-vsi1"
  vpc     = ibm_is_vpc.vpc-instance.id
  keys    = [data.ibm_is_ssh_key.ssh_key_id.id]
  zone    = local.ZONE
  image   = data.ibm_is_image.debian.id
  profile = var.manager_profile

  # References to the subnet and security groups
  primary_network_interface {
    subnet          = ibm_is_subnet.subnet1.id
    security_groups = [ibm_is_security_group.sg1.id]
  }
}

resource "ibm_is_floating_ip" "fip1-manager" {
  name   = "${local.BASENAME}-manager-fip1"
  target = ibm_is_instance.vsi-Manager.primary_network_interface[0].id
}