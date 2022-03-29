# Toy GPU Scheduler

From-scratch toy implementation of a custom kube-scheduler with a super naïve GPU best-fit scheduling algorithm.

## Quickstart

Make use of `deploy/as-deployment.yaml` to install this scheduler as a Kubernetes Deployment with example ServiceAccount and ClusterRoleBinding configured:

```
kubectl apply -f deploy/as-deployment.yaml
```

Alternatively, make use of `deploy/as-static-pod.yaml` to install this scheduler as a static pod in control plane, similarly to how kube-scheduler is deployed by kubeadm. That is, place the file in somewhere control plane's kubelet handle the static pods' definition files, in most cases `/etc/kubernetes/manifests/`:

```
sudo cp deploy/as-static-pod.yaml /etc/kubernetes/manifests/toy-scheduler.yaml
```

## Build

Refer to `Makefile` for local build commands and to `Dockerfile` for building container images.

## Motivation

100% custom scheduler can be much more flexible than the official extension approaches, especailly for integrating end-to-end scheduling algorithms like RL-based models. Examples and tutorials are relatively rare which makes implementing a custom scheulder from scratch a mission impossible for beginners. The toy in this repo can at least build and run in any modern Kubernetes cluster (tested on 1.20, 1.22 and 1.23).

## How it works

The scheduler's logic is straightforward: watch each incoming pod to be scheduled by this scheduler, choose one of the node by some magical algorithms and assign the pod to the chosen node.

The "magic" part can thus be abstracted and then extended in the future (remember we talked about RL things), see `nodepicker.go` and the toy implementation of GPU bestfit in `gpu_bestfit_picker.go` as an example.

The "assign" part involves some Kubernetes actions such as binding a pod to a node and emitting the scheduling event, which could be found in `scheduler.go`.

## Acknowledgement

Inspiration from [a BAINZAICLOUD blog post](https://banzaicloud.com/blog/k8s-custom-scheduler/) and [martonsereg/random-scheduler](https://github.com/martonsereg/random-scheduler).
