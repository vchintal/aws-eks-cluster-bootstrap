#!/bin/sh 

function handler () {
    export KUBECONFIG=/tmp/kubeconfig
    aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${REGION} 
    kubectl apply -f /bootstrap-manifests
}

