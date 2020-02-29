# Flatcar CoreOS install

- Downloaded ISO

https://docs.flatcar-linux.org/os/booting-with-iso/
https://docs.flatcar-linux.org/os/quickstart/

- increased RAM to 4048MB

```
Type:        Other-64
Memory:      2048MB
CPU:         2 CPU
Legacy BIOS: YES
sdb:         32GB
```

says it's "Flatcar Container Linux by Kinvolk stable (2303.4.0)"

https://docs.flatcar-linux.org/os/installing-to-disk/

- create an ignition config yaml file (to ultimately generate a JSON file)

https://docs.flatcar-linux.org/container-linux-config-transpiler/doc/overview/
https://github.com/coreos/container-linux-config-transpiler/

Validate with **ct**: https://coreos.com/os/docs/latest/configuration.html

- install Flatcar to disk 

(until then, it's running LIVE from the CD image)

```
# on the host build system
ct < ignition.yaml 
# ensure no errors, then output to file
ct < ignition.yaml > ignition.json  # no errors? output to file

# run mini http server with python
python -m SimpleHTTPServer 8000

#on the Flatcar live image
curl http://192.168.1.101:8000/ignition.ign -o ignition.ign
flatcar-install -d /dev/sda -i ignition.json -o vmware_raw -C stable|beta|alpha|edge
```

- reboot


# Appendix

- set static IP

https://docs.flatcar-linux.org/os/network-config-with-networkd/

in /etc/systemd/network/static.network

```
[Match]
Name=enp2s0

[Network]
Address=192.168.1.231/24
Gateway=192.168.1.254
DNS=8.8.8.8 8.8.4.4
```

systemctl restart systemd-networkd


- set hostname

```
hostnamectl set-hostname flatcar23
```

- mount Mac's "/" (not working)

https://coreos.com/os/docs/latest/mounting-storage.html

in /etc/systemd/system/host.mount:

.host:/  /media/hgfs fuse.vmhgfs-fuse allow_other,defaults 0 0
