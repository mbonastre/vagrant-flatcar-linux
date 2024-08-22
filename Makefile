
FLATCAR_CHANEL=beta
FLATCAR_VERSION=4012.1.0
FLATCAR_ARCH=amd64-usr
FLATCAR_BASE_URL=https://${FLATCAR_CHANEL}.release.flatcar-linux.net/${FLATCAR_ARCH}/${FLATCAR_VERSION}
FLATCAR_KERNEL=flatcar_production_pxe.vmlinuz
FLATCAR_INITRD=flatcar_production_pxe_image.cpio.gz
FLATCAR_PYTHON=flatcar-python.raw
VAGRANT_SSH_KEY=https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.key.ed25519
ISO_REQ=iso/${FLATCAR_KERNEL} iso/${FLATCAR_INITRD} iso/boot/grub/grub.cfg
export FLATCAR_PYTHON
export FLATCAR_BASE_URL

all: output-flatcar-vbox

iso:
	mkdir iso

iso/boot: |iso
	mkdir -p iso/boot
iso/boot/grub: |iso/boot
	mkdir -p iso/boot/grub

iso/${FLATCAR_KERNEL}: | iso
	wget -c -N -P iso/ ${FLATCAR_BASE_URL}/${FLATCAR_KERNEL}

iso/${FLATCAR_INITRD}: | iso
	wget -c -N -P iso/ ${FLATCAR_BASE_URL}/${FLATCAR_INITRD}

iso/${FLATCAR_PYTHON}: | iso
	wget -c -N -P iso/ ${FLATCAR_BASE_URL}/${FLATCAR_PYTHON}

vagrant.key.ed25519:
	wget -c -N -P iso/ ${FLATCAR_BASE_URL}/${FLATCAR_PYTHON}

flatcar.iso: ${ISO_REQ}
	grub-mkrescue -o $@ iso

config.yml: config-template.yml
	envsubst  < $< > $@

config.ign: config.yml
	docker run --rm -i quay.io/coreos/butane:latest < $< > $@

iso/boot/grub/grub.cfg: grub-template.cfg config.ign | iso/boot/grub
	BASE64=$$( base64 -w 0 < config.ign ) ; \
	echo $${BASE64} ; \
	IGNITION_CONFIG="data:application/json;base64,$${BASE64}" ; \
	echo $${IGNITION_CONFIG} ; \
	export IGNITION_CONFIG ; \
	envsubst < grub-template.cfg > $@

output-flatcar-vbox: flatcar-vbox.pkr.hcl flatcar.iso
	packer build $<

flatcar.box: flatcar-vagrant.pkr.hcl output-flatcar-vbox vagrant.key.ed25519
	packer build $<

clean:
	rm -rf iso flatcar.iso config.ign config.yml
