# CoreOS install

- Downloaded ISO

    https://coreos.com/os/docs/2387.0.0/booting-with-iso.html
    https://coreos.com/os/docs/latest/booting-with-iso.html

- 2411 booted with "Failed to start Switch Root"; increased RAM to 2048MB

    Type:   Other-64bit
    Memory: 2048MB
    CPU:    2 CPU
    Legacy BIOS: YES
    Shared: /Users/vilain
    sdb:    32GB

says it's "CoreOS 2303.4.0"

    https://coreos.com/os/docs/latest/installing-to-disk.html

- create an ignition config yaml file (to ultimately generate a JSON file)

  - https://coreos.com/ignition/docs/latest/examples.html
  - Validate with **ct**: https://github.com/coreos/container-linux-config-transpiler
  - Configuration spec: https://github.com/coreos/container-linux-config-transpiler/blob/master/doc/configuration.md

```

```

- install CoreOS to disk 

(until then, it's running LIVE from the CD image)

```
# on the host build system
ct < ignition.yaml 
# ensure no errors, then output to file
ct < ignition.yaml > ignition.json  # no errors? output to file

#on the CoreOS live image, 
coreos-install -d /dev/sda -c ignition.json -o vmware_raw
```

- reboot

# Appendix

- set static IP

https://coreos.com/os/docs/latest/network-config-with-networkd.html

in /etc/systemd/network/static.network

```
[Match]
Name=ens32

[Network]
Address=192.168.1.224/24
Gateway=192.168.1.254
DNS=8.8.8.8 8.8.4.4
```

systemctl restart systemd-networkd

- set hostname

    hostnamectl set-hostname coreos24


- mount Mac's "/" (not working)

https://coreos.com/os/docs/latest/mounting-storage.html

in /etc/systemd/system/host.mount:

    .host:/  /media/hgfs fuse.vmhgfs-fuse allow_other,defaults 0 0


## Cloud Config (deprecated)

https://coreos.com/os/docs/latest/cloud-config.html
Validate with: https://coreos.com/validate/

    coreos-install -d /dev/sda -c cloud-config.yaml -o vmware_raw


```
#cloud-config

hostname: "coreos1"
ssh_authorized_keys:
  - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZzrQD/FDCnNsTOKMRrvjZIhu+NVMeJuFiwA0YR1kCjLTvcSnroE2s+XEhaWonrZckA2Mt1ieHY+O2iWVqYFu7wwqMXlc6iJdBp4BmpjEmKJaXDb5s7SWZTWyUHseSHDQtP1MGPmGBDAms/mxhDw8OPnHA1wUt4FwnWUW4kBEBL3M0rPkXpxR6X84UdhCTvRihLHUFhSDhmqDJhPTBPuuR9GENhvSsopY0p/B+0ys5ym7U0qHQCwD8ctbf/soGPicHLYFhTDV2EnHI3wFpz9VoJ/4bOxuWDy1w2maY2Gu7S54E7jAxzXEULu//8TcfQCYYYRbnMqs28qP2CldTp+AL coreos"

users:
  - name: core
    passwd: "$6$rTZyy4jR$csRM9u.QjHFKv0DVJTBp.0lTtl7semjDvJ32L6ZiJ/eBbp8O8vRQe.ZNJTqsa3zqKWP82gu1Cdmp3Wn.H9vPm."
  - name: vilain
    passwd: $6$rTZyy4jR$csRM9u.QjHFKv0DVJTBp.0lTtl7semjDvJ32L6ZiJ/eBbp8O8vRQe.ZNJTqsa3zqKWP82gu1Cdmp3Wn.H9vPm.
    ssh_authorized_keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZzrQD/FDCnNsTOKMRrvjZIhu+NVMeJuFiwA0YR1kCjLTvcSnroE2s+XEhaWonrZckA2Mt1ieHY+O2iWVqYFu7wwqMXlc6iJdBp4BmpjEmKJaXDb5s7SWZTWyUHseSHDQtP1MGPmGBDAms/mxhDw8OPnHA1wUt4FwnWUW4kBEBL3M0rPkXpxR6X84UdhCTvRihLHUFhSDhmqDJhPTBPuuR9GENhvSsopY0p/B+0ys5ym7U0qHQCwD8ctbf/soGPicHLYFhTDV2EnHI3wFpz9VoJ/4bOxuWDy1w2maY2Gu7S54E7jAxzXEULu//8TcfQCYYYRbnMqs28qP2CldTp+AL coreos"
    groups: [ sudo, docker ]

write_files: 
  - path: /etc/sudoers.d/vilain
    owner: root
    permissions: "0600"
    content: "vilain ALL=(ALL) NOPASSWD: ALL"

coreos:
  units:
    - name: 00-ens32.network
      enable: true
      content: |
        [Match]
        Name=ens32
      
        [Network]
        DNS=8.8.8.8 8.8.6.6
        Address=192.168.1.224/24
        Gateway=192.168.1.254

    - name: format-var-lib-docker.service
      content: |
        [Unit]
        Before=docker.service var-lib-docker.mount
        RequiresMountsFor=/var/lib
        ConditionPathExists=!/var/lib/docker

        [Service]
        Type=oneshot
        RemainAfterExit=yes
        ExecStart=-/sbin/parted -s /dev/sdb mklabel gpt
        ExecStart=-/sbin/parted -s /dev/sdb mkpart ext4 0 85%
        ExecStart=-/usr/sbin/mkfs.ext4 /dev/sdb1

    - name: var-lib-docker.mount
      enable: true
      command: start
      content: |
        [Unit]
        Before=docker.service
        After=format-var-lib-docker.service
        Requires=format-var-lib-docker.service

        [Mount]
        What=/dev/sdb1
        Where=/var/lib/docker
        Type=ext4
        Options=defaults
        #Options=loop,discard
        [Install]
        RequiredBy=docker.service

    - name: docker.service
      enable: true
      command: start
      drop-ins:
        - name: 10-wait-docker.conf
          content: |
            [Unit]
            After=var-lib-docker.mount
            Requires=var-lib-docker.mount
```
