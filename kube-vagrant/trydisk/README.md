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
parted /dev/sdb mklabel msdos
parted /dev/sdb mkpart primary 512 100%
mkfs.xfs /dev/sdb1
mkdir /mnt/disk
echo `blkid /dev/sdb1 | awk '{print$2}' | sed -e 's/"//g'` /mnt/disk   xfs   noatime,nobarrier   0   0 >> /etc/fstab
mount /mnt/disk
```

`vagrant plugin install vagrant-persistent-storage`
https://github.com/kusnier/vagrant-persistent-storage