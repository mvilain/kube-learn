# Kubernetes the hard way

Notes from Kelsey Hightower's blog 

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

