# kubernetes in vagrant

This code defines a Vagrant installation of kubernetes master and worker nodes.

https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/

- assume Unbuntu xenial (16.04) box
- master is IP 192.168.50.10
- workers are IP 192.168.50.{10+#} where # is 1..x

- calico pod latest


The 
[https://docs.projectcalico.org/v3.4/getting-started/kubernetes/installation/hosted/calico.yaml](calico config file) is out of date and uses API versions that don't match kubernetes V 1.7.3.  The included calico.yaml file provided fixes that.

3/10 used updated calico config to reflect current version of Kubernetes

- docker (latest) xenial

## TO DO

- Doesn't have container volume plugin. Can't run pods that requests storage.
- runs a daemonset and all pods are created so long as they don't require persistant storage


https://askubuntu.com/questions/317338/how-can-i-increase-disk-size-on-a-vagrant-vm
3/12 added vagrant disk-size plugin and added disk requirements to vagrant file
3/13 not used as box has 64GB root partition

```
vagrant plugin install vagrant-disksize

# Install vagrant-disksize to allow resizing the vagrant box disk.
unless Vagrant.has_plugin?("vagrant-disksize")
    raise  Vagrant::Errors::VagrantError.new, "vagrant-disksize plugin is missing. Please install it using 'vagrant plugin install vagrant-disksize' and rerun 'vagrant up'"
end
...
config.disksize.size = '50GB'
```

