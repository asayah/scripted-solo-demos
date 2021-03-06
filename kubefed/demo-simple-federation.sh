#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

SOURCE_DIR=$PWD
source env.sh


desc "Lets see what types the kubefed CP knows about"
run "kubectl get federatedtypeconfigs.core.kubefed.io -A --context $CLUSTER_1"

desc "This maps Kube Types to known FedTypes"

backtotop
desc "For example, let's federate a sample namespac"
run "cat resources/namespace.yaml"

run "kubefedctl federate -f resources/namespace.yaml"

backtotop
desc "Lets apply it"
read -s

desc "First create the test-namespace on the kubefed CP"
run "kubectl create ns test-namespace"

run "kubectl get ns --context $CLUSTER_1"
run "kubectl get ns --context $CLUSTER_2"

run "kubefedctl federate -f resources/namespace.yaml | kubectl --context $CLUSTER_1 apply -f -"

run "kubectl get ns --context $CLUSTER_2"

backtotop
desc "Now let's federate a deployment and a service"
run "kubefedctl federate -f resources/deployment.yaml"

backtotop
desc "Let's deploy some federated resources"
read -s
run "kubefedctl federate -f resources/deployment.yaml | kubectl --context $CLUSTER_1 apply -f -"
run "kubefedctl federate -f resources/service.yaml | kubectl --context $CLUSTER_1 apply -f -"

backtotop
desc "Let's see the status of our federated deployment"
read -s
run "kubectl get federateddeployment --context $CLUSTER_1 -A -o yaml"

run "kubectl get svc -n test-namespace --context $CLUSTER_2"

run "kubectl get po -n test-namespace --context $CLUSTER_1"
run "kubectl get po -n test-namespace --context $CLUSTER_2"


#desc "Let's see how reconciliation on delete works"
#read -s
#desc "If we remove the FederatedNamespace, it will be reconciled"
#run "kubectl delete federatednamespace test-namespace -n test-namespace"

#run "kubectl get ns --context $CLUSTER_2"