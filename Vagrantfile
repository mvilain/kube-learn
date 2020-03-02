# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

APT_SETUP = <<-EOF
    #apt-get update
    if [ ! -e /usr/bin/curl ]; then apt-get install curl; fi
    if [ ! -e /usr/bin/docker ]; then
      curl -fsSL get.docker.com -o get-docker.sh
      sudo sh get-docker.sh
      sudo usermod -aG docker vagrant
    fi
    echo "Install kubectl"
    curl -s -LO https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl 
    chmod +x ./kubectl 
    sudo mv ./kubectl /usr/local/bin/kubectl
    echo "Install minikube"
    curl -s -Lo minikube https://storage.googleapis.com/minikube/releases/v0.22.2/minikube-linux-amd64
    chmod +x minikube
    sudo mv minikube /usr/local/bin/
EOF

Vagrant.configure("2") do |config|
  config.vm.define "kube" do |kube|
    kube.vm.synced_folder '.', '/vagrant', disabled: true
    kube.vm.provider "virtualbox" do |v|
      v.cpus = 2
      v.memory = 2048
#      v.check_guest_additions = false
#      v.functional_vboxsf = false
    end
#    kube.vm.network "public_network", bridge: "en1: Ethernet 2", ip: "192.168.50.10"
#    kube.vm.network "forwarded_port", guest: 80, host: 8000, auto_correct: true
#    kube.vm.network "forwarded_port", guest: 8088, host: 8088, auto_correct: true
    kube.vm.hostname = "kube.local"
    kube.vm.box = "ubuntu/trusty64" #ubuntu/trusty64 amam/flatcar-alpha amam/coreos-alpha
    kube.vm.provision "shell", inline: APT_SETUP
  end
end
