https://kubernetes.io/docs/setup/production-environment/tools/kops/

git@github.com:kubernetes/kops.git

https://groups.google.com/forum/#!topic/kubernetes-users/9ix65M13NNA
---
Ravi 	
11/28/16

I am trying to install k8s on AWS. There are three different methods listed to install.
Is there a comparison page listing when and why should I use each method?

Installing with kubeadm http://kubernetes.io/docs/getting-started-guides/kubeadm/
installing with kops http://kubernetes.io/docs/getting-started-guides/kops/
installing on aws http://kubernetes.io/docs/getting-started-guides/aws/

---
Justin Garrison 	
11/28/16
I'm surprised you only found 3 ways. I don't think there is a comparison page but here is a really quick breakdown from my limited knowledge of each tool. *disclaimer* I've only ever used kube-up

kubeadm: currently alpha tool to initiate clusters on any platform (AWS included). Mostly trying to make a good onboarding experience and make clusters (with https) super easy and replicate some of the docker swarm experience. This is the prefered method going forward but currently is limited in options and doesn't start an HA cluster (only single master)
kops: only works in AWS currently but can create an HA cluster. This is easier to use than kube-up (depending on your use case) and is probably the current best option.
kube-up: The first deployment script. (https://get.k8s.io) Uses a lot of bash + salt and can deploy to multiple cloud providers. I know this still gets updates but not sure if it's the recommended solution going forward. I don't think it sets up an HA cluster but I could be wrong. There are lots of hidden flags/options inside the script and salt config but to my knowledge this still sets up the most "complete" kubernetes cluster

There are many more install options. But I'd probably recommend using kops in AWS or kubeadm for on-prem.

---
Ravi 	
12/6/16
Re: [kubernetes-users] Re: Too many ways to install, which one to pick?

Thanks for your help Justin. Here is my current status

1. I was able to setup a quite complete cluster using kube-up.
Everything works including grafana and kibana. However it is not HA. I
tried to make it HA manually but couldn't. Are there instructions on how
to convert this cluster to HA. AFAIK, only master node is not in auto
scaling group but I am not sure how to add it. Manually adding did not work.

2. KOPS - I was able to setup multi zone HA cluster including master in
auto scaling group. I was able to get dashboard working with instructions at
https://github.com/kubernetes/kops/blob/master/docs/addons.md
However grafana did not work and I could not find instructions to setup
elastic search and kibana.
Are there working instructions to install hipster, kibana, grafana,
influxdb, elastic search etc on it?

- show quoted text -

>     <http://kubernetes.io/docs/getting-started-guides/aws/>
>
