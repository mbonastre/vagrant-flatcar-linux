#
# Flatcar Vagrant builder
#

packer {
    required_plugins {
        virtualbox = {
          version = "~> 1"
          source  = "github.com/hashicorp/virtualbox"
        }
    }
}

source "virtualbox-iso" "flatcar-vbox" {
  guest_os_type = "Linux26_64"
  memory = 3072
  firmware = "efi"
  nested_virt = true
  rtc_time_base = "UTC"
  gfx_controller = "vmsvga"
  gfx_vram_size = "16"
  hard_drive_interface = "sata"
  iso_url = "flatcar.iso"
  iso_checksum = "none"
  ssh_username = "core"
  ssh_private_key_file = "vagrant.key.ed25519"
  shutdown_command = "sudo shutdown -P now"
  guest_additions_mode = "disable"
  boot_wait = "45s"
  boot_command = [
    "<enter><wait>",
    "sudo flatcar-install -d /dev/sda -i /run/ignition.json -u<wait><enter>",
    "<wait2m>"
  ]
}

build {
  sources = ["sources.virtualbox-iso.flatcar-vbox"]
}

