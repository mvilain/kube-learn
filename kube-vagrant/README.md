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

https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/

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

- https://github.com/kusnier/vagrant-persistent-storage

```
vagrant plugin install vagrant-persistent-storage

# Install persistant storage to allow resizing the vagrant box disk.
unless Vagrant.has_plugin?("vagrant-persistent-storage")
    raise  Vagrant::Errors::VagrantError.new, "vagrant-persistent-storage plugin is missing. Please install it using 'vagrant plugin install vagrant-persistent-storage' and rerun 'vagrant up'"
end

```

- https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner/blob/master/helm/README.md

```
$ git clone --depth=1 https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner.git
$ helm template -f <path-to-your-values-file> <release-name> --namespace <namespace> ./helm/provisioner > local-volume-provisioner.generated.yaml
# edit local-volume-provisioner.generated.yaml if necessary
$ kubectl create -f local-volume-provisioner.generated.yaml

e.g.

helm install -f helm/examples/baremetal.yaml local-volume-provisioner --namespace kube-system ./helm/provisioner
```


