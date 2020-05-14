locals {
  BASENAME       = "sneha-test"
  ZONE           = "us-south-1"
  sshkey-private = file("${path.root}/data/id_rsa")
}

resource "ibm_is_vpc" "vpc" {
  name = "${local.BASENAME}-vpc"
}

resource "ibm_is_security_group" "sg1" {
  name = "${local.BASENAME}-sg1"
  vpc  = ibm_is_vpc.vpc.id
}

# allow all incoming network traffic on port 22
resource "ibm_is_security_group_rule" "ingress_ssh_all" {
  group     = ibm_is_security_group.sg1.id
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "ingress_webserver_all" {
  group     = ibm_is_security_group.sg1.id
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "security_group_rule_all" {
  group     = ibm_is_security_group.sg1.id
  direction = "inbound"
  remote    = ibm_is_security_group.sg1.id
}

resource "ibm_is_security_group_rule" "security_group_rule_icmp" {
  group     = ibm_is_security_group.sg1.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  icmp {
    code = 8
  }
}

resource "ibm_is_security_group_rule" "security_group_rule_outbound_all" {
  group     = ibm_is_security_group.sg1.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_security_group_rule" "security_group_rule_outbound_tcp" {
  group     = ibm_is_security_group.sg1.id
  direction = "outbound"
  remote    = ibm_is_floating_ip.fip1.address
  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_subnet" "subnet1" {
  name                     = "${local.BASENAME}-subnet1"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = local.ZONE
  total_ipv4_address_count = 256
}

data "ibm_is_image" "ubuntu" {
  name = "ibm-ubuntu-18-04-3-minimal-ppc64le-4"
}

resource "ibm_is_ssh_key" "ssh_key_id" {
  name = "${local.BASENAME}-sshkey"
  public_key = var.public_key
}

resource "ibm_is_instance" "vsi1" {
  name    = "${local.BASENAME}-vsi1"
  vpc     = ibm_is_vpc.vpc.id
  zone    = local.ZONE
  keys    = [ibm_is_ssh_key.ssh_key_id.id]
  image   = data.ibm_is_image.ubuntu.id
  profile = "bp2-2x8"

  primary_network_interface {
    subnet          = ibm_is_subnet.subnet1.id
    security_groups = [ibm_is_security_group.sg1.id]
  }
}

resource "ibm_is_floating_ip" "fip1" {
  name   = "${local.BASENAME}-fip1"
  target = ibm_is_instance.vsi1.primary_network_interface[0].id
}