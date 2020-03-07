K8S_REGION               = "us-east-2"

K8S_VPC_CIDR             = "10.10.0.0/16"
PUBNET_NAME              = "k8s_pubnet"
PUBNET_CIDR              = "10.10.10.0/24"
PRIVNET_NAME             = "k8s_privnet"
PRIVNET_CIDR             = "10.10.20.0/24"

k8s_whitelist            = [ "190.229.250.0/24" ]

K8S_BUCKET               = "mvilain-prod-tf-backend"
K8S_DYNAMODB_TABLE       = "mvilain-prod-tf-locks"

# CentOS 7 in us-east-2
K8S_AMI                  = "ami-77724e12"
K8S_TYPE                 = "t2.nano"
