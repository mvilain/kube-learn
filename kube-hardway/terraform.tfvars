K8S_REGION               = "us-east-2"
K8S_KEYNAME              = "k8s_key"
K8S_KEY                  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+Uixwro2N0pDn2CBwW+9UjwjTE1VT7u3xliFDp+sqy0mtXHV5uEkjF3GsAqYAE3Bwsu1oz4zrENZsNExFfnjexNnOLR+T+2eeTjKemh6GfqgDMH6tjkXH3vH+mbcl+KjDopFFAEf4+ZVFvQJBAGLzRNGs/gLtDvXiLxPg0dIJIOzUJ5u8sXingOWK2RbgPUL64h5qYUMUyUcWHLIDeJJG5K9BbyoA2Hc5mzU4gV0aBlCC6Qc49lv6pUbL1z2Y0PPekHaVjEh/yfbpd55NdqBvDXABEV+9DSn+akRPz5O2o4ys4alLaJGqEqtVSngBFj1OVB4E5zZ/bqrQVIy0PStT tf-key"

K8S_BUCKET               = "mvilain-prod-tf-backend"
K8S_DYNAMODB_TABLE       = "mvilain-prod-tf-locks"

# CentOS 7 in us-east-2
K8S_AMI                  = "ami-77724e12"
K8S_TYPE                 = "t2.micro"

K8S_VPC_CIDR             = "10.10.0.0/16"
PUBNET_NAME              = "k8s_pubnet"
PUBNET_CIDR              = "10.10.10.0/24"
PRIVNET_NAME             = "k8s_privnet"
PRIVNET_CIDR             = "10.10.20.0/24"

k8s_whitelist            = [ "0.0.0.0/0" ]
