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
source "null" "flatcar-vagrant" {
  communicator = "none"
}

build {
  sources = ["sources.null.flatcar-vagrant"]
  post-processors {
    post-processor "artifice" {
      files = ["output-flatcar-vbox/*"]
    }
    post-processor "vagrant" {
      keep_input_artifact = true
      provider_override   = "virtualbox"
      vagrantfile_template = "BoxVagrantfile-template"
      output = "flatcar.box"
    }
  }
}

