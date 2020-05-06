# Adding labels to the application

## Chapter Goal
1. Adding labels during build time
2. Viewing labels
2. Adding labels to running pods
3. Deleting a label
4. Searching by labels
5. Extending the label concept to deployments/services

### Adding labels during build time

You can add labels to pods, services and deployments either at build time or at run time. If you're adding labels at build time, you can add a label section in the metadata portion of the YAML as shown below:

```
  labels:
    env: production
    author: karthequian
    application_type: ui
    release-version: "1.0"
```

You can deploy the code above by using the command `kubectl create -f helloworld-pod-with-labels.yml`


### Viewing labels

You have a pod with labels. Super! But how do you see them? You can add the `--show-labels` option to your kubectl get command as shown here:

```
> kubectl get pod --show-labels
NAME                  READY   STATUS    RESTARTS   AGE   LABELS
helloworld-lables     1/1     Running   0          14s   application_type=ui,author=karthequian,env=production,release-version=1.0
hw-84f776b79d-c488t   1/1     Running   1          75m   pod-template-hash=84f776b79d,run=hw
```

### Adding labels to running pods
To add labels to a running pod, you can use the `kubectl label` command as follows: `kubectl label po/helloworld app=helloworld`. This adds the label `app` with the value `helloworld` to the pod.

To update the value of a label, use the `--overwrite` flag in the command as follows: `kubectl label po/helloworld-lables app=helloworldapp --overwrite` 

### Deleting a label
To remove an existing label, just add a `-` to the end of the label key as follows: `kubectl label po/helloworld-lables app-`. This will remove the app label from the helloworld pod.

```
> kubectl get pod --show-labels
NAME                  READY   STATUS    RESTARTS   AGE   LABELS
helloworld-lables     1/1     Running   0          14s   application_type=ui,author=karthequian,env=production,release-version=1.0
hw-84f776b79d-c488t   1/1     Running   1          75m   pod-template-hash=84f776b79d,run=hw

> kubectl label po/helloworld-lables app=helloworldapp --overwrite
pod/helloworld-lables labeled
> kubectl get pod --show-labels
NAME                  READY   STATUS    RESTARTS   AGE     LABELS
helloworld-lables     1/1     Running   0          4m35s   app=helloworldapp,application_type=ui,author=karthequian,env=production,release-version=1.0
hw-84f776b79d-c488t   1/1     Running   1          79m     pod-template-hash=84f776b79d,run=hw

> kubectl label po/helloworld-lables app-
pod/helloworld-lables labeled
> kubectl get pod --show-labels
NAME                  READY   STATUS    RESTARTS   AGE     LABELS
helloworld-lables     1/1     Running   0          4m48s   application_type=ui,author=karthequian,env=production,release-version=1.0
hw-84f776b79d-c488t   1/1     Running   1          80m     pod-template-hash=84f776b79d,run=hw
```

### Searching by labels
Creating, getting and deleting labels is nice, but the ability to search using labels helps us identify what's going on in our infrastructure better. Let's take a look. First, we're going to deploy a few pods that will constitute what a small org might have. 

`kubectl create -f kubectl create -f sample-infrastructure-with-labels.yml`

```
kubectl create -f sample-infrastructure-with-labels.yml
pod/homepage-dev created
pod/homepage-staging created
pod/homepage-prod created
pod/login-dev created
pod/login-staging created
pod/login-prod created
pod/cart-dev created
pod/cart-staging created
pod/cart-prod created
pod/social-dev created
pod/social-staging created
pod/social-prod created
pod/catalog-dev created
pod/catalog-staging created
pod/catalog-prod created
pod/quote-dev created
pod/quote-staging created
pod/quote-prod created
pod/ordering-dev created
pod/ordering-staging created
pod/ordering-prod created
```

Looking at these applications running from a high level makes it hard to see what's going on with the infrastructure.

`kubectl get pods`

`kubectl get pods --show-labels`

```
kubectl get pods
NAME                  READY   STATUS              RESTARTS   AGE
cart-dev              0/1     ContainerCreating   0          15s
cart-prod             0/1     ContainerCreating   0          15s
cart-staging          0/1     ContainerCreating   0          15s
catalog-dev           0/1     ContainerCreating   0          14s
catalog-prod          0/1     ContainerCreating   0          14s
catalog-staging       0/1     ContainerCreating   0          14s
helloworld-lables     1/1     Running             0          14m
homepage-dev          0/1     ContainerCreating   0          15s
homepage-prod         0/1     ContainerCreating   0          15s
homepage-staging      0/1     ContainerCreating   0          15s
hw-84f776b79d-c488t   1/1     Running             1          89m
login-dev             0/1     ContainerCreating   0          15s
login-prod            0/1     ContainerCreating   0          15s
login-staging         0/1     ContainerCreating   0          15s
ordering-dev          0/1     ContainerCreating   0          14s
ordering-prod         0/1     ContainerCreating   0          14s
ordering-staging      0/1     ContainerCreating   0          14s
quote-dev             0/1     ContainerCreating   0          14s
quote-prod            0/1     ContainerCreating   0          14s
quote-staging         0/1     ContainerCreating   0          14s
social-dev            0/1     ContainerCreating   0          15s
social-prod           0/1     ContainerCreating   0          14s
social-staging        0/1     ContainerCreating   0          15s

kubectl get pods --show-labels
NAME               READY   STATUS    RESTARTS   AGE     LABELS
cart-dev           1/1     Running   0          3m42s   application_type=api,dev-lead=carisa,env=development,release-version=1.0,team=ecommerce
cart-prod          1/1     Running   0          3m42s   application_type=api,dev-lead=carisa,env=production,release-version=1.0,team=ecommerce
cart-staging       1/1     Running   0          3m42s   application_type=api,dev-lead=carisa,env=staging,release-version=1.0,team=ecommerce
catalog-dev        1/1     Running   0          3m41s   application_type=api,dev-lead=daniel,env=development,release-version=4.0,team=ecommerce
catalog-prod       1/1     Running   0          3m41s   application_type=api,dev-lead=daniel,env=production,release-version=4.0,team=ecommerce
catalog-staging    1/1     Running   0          3m41s   application_type=api,dev-lead=daniel,env=staging,release-version=4.0,team=ecommerce
homepage-dev       1/1     Running   0          3m42s   application_type=ui,dev-lead=karthik,env=development,release-version=12.0,team=web
homepage-prod      1/1     Running   0          3m42s   application_type=ui,dev-lead=karthik,env=production,release-version=12.0,team=web
homepage-staging   1/1     Running   0          3m42s   application_type=ui,dev-lead=karthik,env=staging,release-version=12.0,team=web
login-dev          1/1     Running   0          3m42s   application_type=api,dev-lead=jim,env=development,release-version=1.0,team=auth
login-prod         1/1     Running   0          3m42s   application_type=api,dev-lead=jim,env=production,release-version=1.0,team=auth
login-staging      1/1     Running   0          3m42s   application_type=api,dev-lead=jim,env=staging,release-version=1.0,team=auth
ordering-dev       1/1     Running   0          3m41s   application_type=backend,dev-lead=chen,env=development,release-version=2.0,team=purchasing
ordering-prod      1/1     Running   0          3m41s   application_type=backend,dev-lead=chen,env=production,release-version=2.0,team=purchasing
ordering-staging   1/1     Running   0          3m41s   application_type=backend,dev-lead=chen,env=staging,release-version=2.0,team=purchasing
quote-dev          1/1     Running   0          3m41s   application_type=api,dev-lead=amy,env=development,release-version=2.0,team=ecommerce
quote-prod         1/1     Running   0          3m41s   application_type=api,dev-lead=amy,env=production,release-version=1.0,team=ecommerce
quote-staging      1/1     Running   0          3m41s   application_type=api,dev-lead=amy,env=staging,release-version=2.0,team=ecommerce
social-dev         1/1     Running   0          3m42s   application_type=api,dev-lead=carisa,env=development,release-version=2.0,team=marketing
social-prod        1/1     Running   0          3m41s   application_type=api,dev-lead=marketing,env=production,release-version=1.0,team=marketing
social-staging     1/1     Running   0          3m42s   application_type=api,dev-lead=marketing,env=staging,release-version=1.0,team=marketing
```

You can search for labels with the flag `--selector` (or `-l`). If you want to search for all the pods that are running in production, you can run `kubectl get pods --selector env=production` as shown below:

`kubectl get pods --selector env=production`


```
kubectl get pods --selector env=production
NAME            READY   STATUS    RESTARTS   AGE
cart-prod       1/1     Running   1          10m
catalog-prod    1/1     Running   0          10m
homepage-prod   1/1     Running   0          10m
login-prod      1/1     Running   1          10m
ordering-prod   1/1     Running   0          10m
quote-prod      1/1     Running   0          10m
social-prod     1/1     Running   1          10m
```

Similarly, to get all pods by dev lead Karthik, you'd add `dev-lead=karthik` to the selector as shown below.

`kubectl get pods --selector dev-lead=karthik`

```
kubectl get pods --selector dev-lead=karthik
NAME               READY   STATUS    RESTARTS   AGE
homepage-dev       1/1     Running   0          8m1s
homepage-prod      1/1     Running   0          8m1s
homepage-staging   1/1     Running   0          8m1s
```

You can also do more complicated searches, like finding any pods owned by Karthik in the development tier, by the following query `dev-lead=karthik,env=staging`:

`kubectl get pods -l dev-lead=karthik,env=staging`

```
kubectl get pods --selector dev-lead=karthik,env=staging
NAME               READY   STATUS    RESTARTS   AGE
homepage-staging   1/1     Running   0          8m39s
```

Or, any apps not owned by Karthik in staging (using the ! construct):

`kubectl get pods -l dev-lead!=karthik,env=staging`

```
kubectl get pods --selector dev-lead!=karthik,env=staging
NAME               READY   STATUS    RESTARTS   AGE
cart-staging       1/1     Running   1          11m
catalog-staging    1/1     Running   1          11m
login-staging      1/1     Running   1          11m
ordering-staging   1/1     Running   1          11m
quote-staging      1/1     Running   1          11m
social-staging     1/1     Running   1          11m

kubectl get pods --selector dev-lead!=karthik,env=staging --show-labels
NAME               READY   STATUS    RESTARTS   AGE   LABELS
cart-staging       1/1     Running   1          12m   application_type=api,dev-lead=carisa,env=staging,release-version=1.0,team=ecommerce
catalog-staging    1/1     Running   1          12m   application_type=api,dev-lead=daniel,env=staging,release-version=4.0,team=ecommerce
login-staging      1/1     Running   1          12m   application_type=api,dev-lead=jim,env=staging,release-version=1.0,team=auth
ordering-staging   1/1     Running   1          12m   application_type=backend,dev-lead=chen,env=staging,release-version=2.0,team=purchasing
quote-staging      1/1     Running   1          12m   application_type=api,dev-lead=amy,env=staging,release-version=2.0,team=ecommerce
social-staging     1/1     Running   1          12m   application_type=api,dev-lead=marketing,env=staging,release-version=1.0,team=marketing
```

Querying also supports the `in` keyword

`kubectl get pods -l 'release-version in (1.0,2.0)'`

```
kubectl get pods -l 'release-version in (1.0,2.0)'
NAME               READY   STATUS    RESTARTS   AGE
cart-dev           1/1     Running   1          19m
cart-prod          1/1     Running   1          19m
cart-staging       1/1     Running   1          19m
login-dev          1/1     Running   1          19m
login-prod         1/1     Running   1          19m
login-staging      1/1     Running   1          19m
ordering-dev       1/1     Running   1          19m
ordering-prod      1/1     Running   1          19m
ordering-staging   1/1     Running   1          19m
quote-dev          1/1     Running   1          19m
quote-prod         1/1     Running   1          19m
quote-staging      1/1     Running   1          19m
social-dev         1/1     Running   1          19m
social-prod        1/1     Running   1          19m
social-staging     1/1     Running   1          19m

kubectl get pods -l 'release-version in (1.0,2.0)' --show-labels
NAME               READY   STATUS      RESTARTS   AGE   LABELS
cart-dev           1/1     Running     2          20m   application_type=api,dev-lead=carisa,env=development,release-version=1.0,team=ecommerce
cart-prod          1/1     Running     2          20m   application_type=api,dev-lead=carisa,env=production,release-version=1.0,team=ecommerce
cart-staging       1/1     Running     2          20m   application_type=api,dev-lead=carisa,env=staging,release-version=1.0,team=ecommerce
login-dev          0/1     Completed   1          20m   application_type=api,dev-lead=jim,env=development,release-version=1.0,team=auth
login-prod         1/1     Running     2          20m   application_type=api,dev-lead=jim,env=production,release-version=1.0,team=auth
login-staging      1/1     Running     2          20m   application_type=api,dev-lead=jim,env=staging,release-version=1.0,team=auth
ordering-dev       1/1     Running     1          20m   application_type=backend,dev-lead=chen,env=development,release-version=2.0,team=purchasing
ordering-prod      1/1     Running     1          20m   application_type=backend,dev-lead=chen,env=production,release-version=2.0,team=purchasing
ordering-staging   1/1     Running     1          20m   application_type=backend,dev-lead=chen,env=staging,release-version=2.0,team=purchasing
quote-dev          1/1     Running     1          20m   application_type=api,dev-lead=amy,env=development,release-version=2.0,team=ecommerce
quote-prod         1/1     Running     1          20m   application_type=api,dev-lead=amy,env=production,release-version=1.0,team=ecommerce
quote-staging      0/1     Completed   1          20m   application_type=api,dev-lead=amy,env=staging,release-version=2.0,team=ecommerce
social-dev         1/1     Running     2          20m   application_type=api,dev-lead=carisa,env=development,release-version=2.0,team=marketing
social-prod        1/1     Running     2          20m   application_type=api,dev-lead=marketing,env=production,release-version=1.0,team=marketing
social-staging     1/1     Running     1          20m   application_type=api,dev-lead=marketing,env=staging,release-version=1.0,team=marketing
```

Or a more complicated example:

`kubectl get pods -l "release-version in (1.0,2.0),team in (marketing,ecommerce)"`

```
kubectl get pods -l "release-version in (1.0,2.0),team in (marketing,ecommerce)"
NAME             READY   STATUS    RESTARTS   AGE
cart-dev         1/1     Running   2          22m
cart-prod        1/1     Running   2          22m
cart-staging     1/1     Running   2          22m
quote-dev        1/1     Running   2          22m
quote-prod       1/1     Running   2          22m
quote-staging    1/1     Running   2          22m
social-dev       1/1     Running   2          22m
social-prod      1/1     Running   2          22m
social-staging   1/1     Running   2          22m
```

The opposite of "in" is "notin". Surprise. "Notin" is supported as well, as shown in this example:

`kubectl get pods -l 'release-version notin (1.0,2.0)'`

```
kubectl get pods -l 'release-version notin (1.0,2.0)' --show-labels
NAME               READY   STATUS    RESTARTS   AGE   LABELS
catalog-dev        1/1     Running   2          21m   application_type=api,dev-lead=daniel,env=development,release-version=4.0,team=ecommerce
catalog-prod       1/1     Running   2          21m   application_type=api,dev-lead=daniel,env=production,release-version=4.0,team=ecommerce
catalog-staging    1/1     Running   2          21m   application_type=api,dev-lead=daniel,env=staging,release-version=4.0,team=ecommerce
homepage-dev       1/1     Running   0          21m   application_type=ui,dev-lead=karthik,env=development,release-version=12.0,team=web
homepage-prod      1/1     Running   0          21m   application_type=ui,dev-lead=karthik,env=production,release-version=12.0,team=web
homepage-staging   1/1     Running   0          21m   application_type=ui,dev-lead=karthik,env=staging,release-version=12.0,team=web
```

Finally, sometimes your label might not have a value assigned to it, but you can still search by label name.

`kubectl get pods -l 'release-version'`  

```
kubectl get pods -l 'release-version'
NAME               READY   STATUS    RESTARTS   AGE
cart-dev           1/1     Running   2          23m
cart-prod          1/1     Running   2          23m
cart-staging       1/1     Running   2          23m
catalog-dev        1/1     Running   2          23m
catalog-prod       1/1     Running   2          23m
catalog-staging    1/1     Running   2          23m
homepage-dev       1/1     Running   0          23m
homepage-prod      1/1     Running   0          23m
homepage-staging   1/1     Running   0          23m
login-dev          1/1     Running   2          23m
login-prod         1/1     Running   2          23m
login-staging      1/1     Running   2          23m
ordering-dev       1/1     Running   2          23m
ordering-prod      1/1     Running   2          23m
ordering-staging   1/1     Running   2          23m
quote-dev          1/1     Running   2          23m
quote-prod         1/1     Running   2          23m
quote-staging      1/1     Running   2          23m
social-dev         1/1     Running   2          23m
social-prod        1/1     Running   2          23m
social-staging     1/1     Running   2          23m
```

### Extending the label concept to deployments/services

As a bonus, labels will also work with `kubectl get services/deployments/all --show-labels` and will return labels for your services, deployments or all objects.

```
kubectl get all --show-labels
NAME                   READY   STATUS    RESTARTS   AGE   LABELS
pod/cart-dev           1/1     Running   2          24m   application_type=api,dev-lead=carisa,env=development,release-version=1.0,team=ecommerce
pod/cart-prod          1/1     Running   2          24m   application_type=api,dev-lead=carisa,env=production,release-version=1.0,team=ecommerce
pod/cart-staging       1/1     Running   2          24m   application_type=api,dev-lead=carisa,env=staging,release-version=1.0,team=ecommerce
pod/catalog-dev        1/1     Running   2          24m   application_type=api,dev-lead=daniel,env=development,release-version=4.0,team=ecommerce
pod/catalog-prod       1/1     Running   2          24m   application_type=api,dev-lead=daniel,env=production,release-version=4.0,team=ecommerce
pod/catalog-staging    1/1     Running   2          24m   application_type=api,dev-lead=daniel,env=staging,release-version=4.0,team=ecommerce
pod/homepage-dev       1/1     Running   0          24m   application_type=ui,dev-lead=karthik,env=development,release-version=12.0,team=web
pod/homepage-prod      1/1     Running   0          24m   application_type=ui,dev-lead=karthik,env=production,release-version=12.0,team=web
pod/homepage-staging   1/1     Running   0          24m   application_type=ui,dev-lead=karthik,env=staging,release-version=12.0,team=web
pod/login-dev          1/1     Running   2          24m   application_type=api,dev-lead=jim,env=development,release-version=1.0,team=auth
pod/login-prod         1/1     Running   2          24m   application_type=api,dev-lead=jim,env=production,release-version=1.0,team=auth
pod/login-staging      1/1     Running   2          24m   application_type=api,dev-lead=jim,env=staging,release-version=1.0,team=auth
pod/ordering-dev       1/1     Running   2          24m   application_type=backend,dev-lead=chen,env=development,release-version=2.0,team=purchasing
pod/ordering-prod      1/1     Running   2          24m   application_type=backend,dev-lead=chen,env=production,release-version=2.0,team=purchasing
pod/ordering-staging   1/1     Running   2          24m   application_type=backend,dev-lead=chen,env=staging,release-version=2.0,team=purchasing
pod/quote-dev          1/1     Running   2          24m   application_type=api,dev-lead=amy,env=development,release-version=2.0,team=ecommerce
pod/quote-prod         1/1     Running   2          24m   application_type=api,dev-lead=amy,env=production,release-version=1.0,team=ecommerce
pod/quote-staging      1/1     Running   2          24m   application_type=api,dev-lead=amy,env=staging,release-version=2.0,team=ecommerce
pod/social-dev         1/1     Running   2          24m   application_type=api,dev-lead=carisa,env=development,release-version=2.0,team=marketing
pod/social-prod        1/1     Running   2          24m   application_type=api,dev-lead=marketing,env=production,release-version=1.0,team=marketing
pod/social-staging     1/1     Running   2          24m   application_type=api,dev-lead=marketing,env=staging,release-version=1.0,team=marketing

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    LABELS
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   113m   component=apiserver,provider=kubernetes
```

And, you can delete pods, services or deployments by label as well! For example `kubectl delete pods -l dev-lead=karthik` will delete all pods who's dev-lead was Karthik. 

```
kubectl delete pods -l dev-lead=karthik
pod "homepage-dev" deleted
pod "homepage-prod" deleted
pod "homepage-staging" deleted
```

To summarize, labels in Kubernetes is a powerful concept! Use the labeling feature to your advantage to build your infrastructure in an organized fashion.
