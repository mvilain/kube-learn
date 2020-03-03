# Kubernetes the hard way

Notes from Kelsey Hightower's blog 

AWS us-east-2 CoreOS AMI  ami-08c51fc1b1cc85501

https://github.com/kelseyhightower/kubernetes-the-hard-way/

gcloud config configurations create hard-way --activate
gcloud config configurations list
gcloud config configurations describe hard-way --all

gcloud compute networks list
gcloud compute networks create kube-hardway --subnet-mode custom

gcloud compute networks subnets list
gcloud compute networks subnets create kubernetes \
  --network kube-hardway  \
  --range 10.240.0.0/24

gcloud compute firewall-rules list
gcloud compute firewall-rules create kube-hardway-allow-internal  \
  --allow tcp,udp,icmp  \
  --network kube-hardway  \
  --source-ranges 10.240.0.0/24,10.200.0.0/16
gcloud compute firewall-rules create kube-hardway-allow-external  \
  --allow tcp:22,tcp:6443,icmp  \
  --network kube-hardway  \
  --source-ranges 0.0.0.0/0

gcloud compute addresses list
gcloud compute addresses create kube-hardway \
  --region $(gcloud config get-value compute/region)

for i in 0 1 2; do
  gcloud compute instances create controller-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-1804-lts \
    --image-project ubuntu-os-cloud \
    --machine-type n1-standard-1 \
    --private-network-ip 10.240.0.1${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes \
    --tags kube-hardway,controller
done
for i in 0 1 2; do
  gcloud compute instances create worker-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-1804-lts \
    --image-project ubuntu-os-cloud \
    --machine-type n1-standard-1 \
    --metadata pod-cidr=10.200.${i}.0/24 \
    --private-network-ip 10.240.0.2${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes \
    --tags kube-hardway,worker
done
gcloud compute instances list

gcloud compute ssh controller-0