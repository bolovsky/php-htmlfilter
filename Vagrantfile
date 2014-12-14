# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "bolovsky/trusty64-lemp"
  config.vm.network "public_network"
  config.vm.network "private_network", ip: "192.168.12.101"
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

end
