# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04-i386"
  #config.vm.box_url = "http://files.vagrantup.com/trusty32.box"
  config.vm.network :private_network, ip: "192.168.56.2"

  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    vb.gui = true
 
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  config.vm.provision :shell, :path => "after_init.sh" 
end
