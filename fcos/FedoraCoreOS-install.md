# Fedora CoreOS install

- Downloaded ISO

https://getfedora.org/en/coreos/download/

https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/
https://docs.fedoraproject.org/en-US/fedora-coreos/bare-metal/

- increased RAM to 4048MB

Type:        Fedora-64
Memory:      4096MB
CPU:         2 CPU
Legacy BIOS: YES
sdb:         32GB

says it's "CoreOS 2303.4.0"

https://coreos.com/os/docs/latest/installing-to-disk.html

- create an ignition config yaml file (to ultimately generate a JSON file)

https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/
https://docs.fedoraproject.org/en-US/fedora-coreos/fcct-config/





Validate with **fcct**: https://github.com/coreos/fcct
Configuration spec: 

```
variant: fcos
version: 1.0.0
passwd:
  users:
    - name: core
      ssh_authorized_keys:

```

- install CoreOS to disk 

(until then, it's running LIVE from the CD image)

```
# on the host build system
ct < ignition.yaml 
# ensure no errors, then output to file
ct < ignition.yaml > ignition.json  # no errors? output to file

# run mini http server with python
python -m SimpleHTTPServer 8000

#on the CoreOS live image
curl http://192.168.1.101:8000/ignition.ign -o ignition.ign
coreos-installer install /dev/sda -i example.ign
```

- reboot




# Appendix

- set static IP

https://docs.fedoraproject.org/en-US/fedora-coreos/static-ip-config/
https://developer.gnome.org/NetworkManager/stable/nm-settings-keyfile.html

in /etc/NetworkManager/system-connections/eth0.nmconnection

```
[connection]
type=ethernet
interface-name=eth0

[ethernet]
mac-address=<insert MAC address>

[ipv4]
method=manual
addresses=192.168.1.31/24
gateway=192.168.1.254
dns=8.8.8.8;8.8.4.4
```

nmcli connection down eth0
nmcli connection up eth0


- set hostname

```
hostnamectl coreos24 set-hostname coreos24
```

- mount Mac's "/" (not working)

https://coreos.com/os/docs/latest/mounting-storage.html

in /etc/systemd/system/host.mount:

.host:/  /media/hgfs fuse.vmhgfs-fuse allow_other,defaults 0 0
