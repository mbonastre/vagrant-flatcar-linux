#
# Flatcar Vagrant builder
#

packer {
  required_plugins {
    vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

#
# Nothing to build: the files we need are the output from flatcar-vbox.pkr.hcl
#
source "null" "flatcar-vagrant-registry" {
  communicator = "none"
}

variable "hcp_client_id" {
  type    = string
  default = "${env("HCP_CLIENT_ID")}"
}

variable "hcp_client_secret" {
  type    = string
  default = "${env("HCP_CLIENT_SECRET")}"
}

build {
  sources = ["sources.null.flatcar-vagrant-registry"]

  post-processors {
    post-processor "artifice" {
      files = ["flatcar.box"]
    }
    post-processor "vagrant-registry" {
      client_id     = "${var.hcp_client_id}"
      client_secret = "${var.hcp_client_secret}"
      box_tag      = "mbonastre-org/flatcar"
      version      = "0.1.0"
      architecture = "amd64"
    }
  }
}