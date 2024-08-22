# vagrant-flatcar-linux
Create a Flatcar Container Linux Vagrant Box

grub-mkrescue:
- Create iso image with grub and flatcar PXE images
- Flatcar ignition config embedded in kernel command line

Packer Step 1:
- Create VirtualBox machine from iso image
- Launch flatcar-install
- Export resulting VirtualBox Machine

Packer Step 2:
- Create Vagrant box from VirtualBox machine

Packer Step 3:
- Publish to Hashicorp registry the resulting box

TODO:
- Dynamicaly get Vagrant SSH default keys (aka "insecure")
  (instead of hardcoded)
