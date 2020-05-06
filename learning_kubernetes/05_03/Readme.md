# Working with configmaps

## Chapter Goals
1. Learn how to declare a configmap
2. Understand how to call a configmap from a deployment

*NOTE*: original yaml files were out of date and missing a selector field

### Learn how to declare a configmap
Applications require a way for us to pass data to them that can be changed at deploy time. Examples of this might be log-levels or urls of external systems that the application might need at startup time. Instead of hardcoding these values, we can use a configmap in kubernetes, and pass these values as environment variables to the container.

We will take an example of "log_level", and pass the value "debug" to a pod via a configmap in this example.

To create a configmap for this literal type 

    kubectl create configmap logger --from-literal=log_level=debug

To see all your configmaps: `kubectl get configmaps`

To read the value in the logger configmap: `kubectl get configmap/logger -o yaml`

To edit the value, we can run `kubectl edit configmap/logger`

### Understand how to call a configmap from a deployment

*NOTE*: if you change the value in the configmap, the container doesn't necessarily pickt that up unless the code queries the value continously.  Usually the value is only read when the container is started.

To pick up the new value, you have to start a new pod or change the value of the variable in the deployment 

kubectl set env deployment/logreader-dynamic log_level=DEBUG

it will shut down the old pod and start the new one with the value specified