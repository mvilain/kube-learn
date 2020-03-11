# kubernetes in vagrant

This code defines a Vagrant installation of kubernetes master and worker nodes.

https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/

- assume Unbuntu xenial (16.04) box
- master is IP 192.168.50.10
- workers are IP 192.168.50.{10+#} where # is 1..x

- calico pod v3.4


The 
[https://docs.projectcalico.org/v3.4/getting-started/kubernetes/installation/hosted/calico.yaml](calico config file) is out of date and uses API versions that don't match kubernetes V 1.7.3.  The included calico.yaml file provided fixes that.

- docker (latest) xenial

## TO DO

- Doesn't have container volume plugin. Can't run pods that requests storage.
- runs a daemonset and all pods are created so long as they don't require persistant storage
