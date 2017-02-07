# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "alltiersolutions/centos-7.3-64-nocm"

  config.vm.network "forwarded_port", guest: 5601, host: 5601

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.provision "shell", path: "shell/provision.sh"

end
