K8S_REGION               = "us-east-2"
K8S_KEYNAME              = "k8s-key"
# aws ec2 create-key-pair --key-name tf-key
# ssh-keygen -C tf-key -b 2048 -m PEM -f tf-key
K8S_KEY                  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcWhXXCtJOr1AMXsYlvu6M91UW7LFqV6u/4J+RyLPt0ZpCjfRPFynYoTGuJOadAWBHltUl44yRclVLO3a4rQoPdIyubxjcNvaJGRAI8EbXHCbFWMIksy8xRqMmYtsnbPWr9FLOivUP8qDUS1mrkOF0NeAiGGDqLJoMg2kkF6xwFW4uyGun+tcRvmQxZNiF6DSMdlj3sLuEvyRL6kDgY/NRkuMG+9zVEnLnCQYNfzNWMxU7N4vbFIoY5gH00Mo0Gbr0A5H9aT6TRyrRbcoa5n2HqLZf/yZ4nPnRc3H0frW1YiqslgV+KvE+Y9vouSjs2OsRof0dh6PIBAeKt6N5gDHx tf-key"

K8S_BUCKET               = "mvilain-prod-tf-backend"
K8S_DYNAMODB_TABLE       = "mvilain-prod-tf-locks"

# Ubuntu-18.04LTS in us-east-2
K8S_AMI                  = "ami-0fc20dd1da406780b"
K8S_TYPE                 = "t2.micro"

K8S_VPC_CIDR             = "10.10.0.0/16"
PUBNET_NAME              = "k8s_pubnet"
PUBNET_CIDR              = "10.10.10.0/24"
PRIVNET_NAME             = "k8s_privnet"
PRIVNET_CIDR             = "10.10.20.0/24"

k8s_whitelist            = [ "0.0.0.0/0" ]
