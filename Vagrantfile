# -*- mode: ruby -*-
# vi: set ft=ruby

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "server" do |nodo|
    nodo.vm.box = "generic/rhel7"
    nodo.vm.hostname = "server"
    nodo.vm.network "private_network", ip: "192.168.33.10"
    nodo.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
  end 
  config.vm.define "desktop" do |nodo|
    nodo.vm.box = "generic/rhel7"
    nodo.vm.hostname = "desktop"
    nodo.vm.network "private_network", ip: "192.168.33.11"
    nodo.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
    end
  end
end

