# Bootstrapping an EKS Cluster with Private API Endpoint 

> **Note**❗ This is proof-of-concept material and is not intended to be used 
> for Production workloads as-is. Use this repo at your own risk.

### Prerequisites

Ensure that you have installed the following tools locally:

* git
* terraform

### Preparation 

```sh 
git clone https://github.com/vchintal/aws-eks-cluster-bootstrap
cd  aws-eks-cluster-bootstrap
```

Place all the manifests that need to be deployed in the folder `container-image/bootstrap-manifests` and ensure that either `namespace` is not mentioned or is 
set to `default` (see the note below). 

> **Note:** In this repo, we are allowing the Lambda to setup resources in the 
> `default` namespace only.

### Deploy 

```
alias t="terraform"
t init 
t apply --auto-approve
```

### Destroy 
```
t destroy --auto-approve
```

### Verification 

Use the EKS web console to verify that the `busybox` deployment is running in 
`default` namespace.