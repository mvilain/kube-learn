# kubernetes in vagrant

This code defines a Vagrant installation of kubernetes master and worker nodes.

https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/

- assume Unbuntu xenial (16.04) box
- master is IP 192.168.50.10
- workers are IP 192.168.50.{10+#} where # is 1..x

- calico pod v3.4
- docker (latest) xenial