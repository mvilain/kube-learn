# Adding drives to Vagrant Virtual boxes


https://coderwall.com/p/5uwiig/add-a-second-disk-to-system-using-vagrant
https://gist.github.com/drmalex07/e9f543766eea14ececc6a8c668921871
https://gist.github.com/leifg/4713995

```
config.vm.provider "virtualbox" do |v|
  v.memory = 2048
  v.cpus = 2

VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))
file_to_disk = File.join(VAGRANT_ROOT, 'filename.vdi')

unless File.exist?(file_to_disk)
   v.customize [ "createmedium", "disk", "--filename", #{file_to_disk}, 
"--format", "vmdk", "--size", 1024 * 10 ]
end
  v.customize [ "storageattach", "myvm" , "--storagectl", 
"IDE Controller", "--port", "1", "--device", "0", "--type", 
"hdd", "--medium", #{file_to_disk} ]
end
```

part of bootstrap.sh
```
set -e
set -x

if [ -f /etc/provision_env_disk_added_date ]
then
   echo "Provision runtime already done."
   exit 0
fi


sudo fdisk -u /dev/sdb <<EOF
n
p
1

+500M
n
p
2


w
EOF

mkfs.ext4 /dev/sdb1
mkfs.ext4 /dev/sdb2
mkdir -p /{data,extra}
mount -t ext4 /dev/sdb1 /data
mount -t ext4 /dev/sdb2 /extra
```

`vagrant plugin install vagrant-persistent-storage`
https://github.com/kusnier/vagrant-persistent-storage