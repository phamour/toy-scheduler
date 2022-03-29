package main

import (
	"flag"
	"path/filepath"

	v1 "k8s.io/api/core/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"
	"k8s.io/klog/v2"
)

func LoadConfig() *rest.Config {
	config, err := rest.InClusterConfig()
	if err != nil {
		klog.Warning("failed to load in-cluster config, trying to load out-of-cluster config")

		config, err = OutClusterConfig()
		if err != nil {
			klog.Error(("failed to load out-of-cluster config, abort"))
			panic(err.Error())
		}
	}
	return config
}

func OutClusterConfig() (*rest.Config, error) {
	var kubeconfig *string
	if home := homedir.HomeDir(); home != "" {
		kubeconfig = flag.String("kubeconfig", filepath.Join(home, ".kube", "config"), "(optional) absolute path to the kubeconfig file")
	} else {
		kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
	}
	flag.Parse()
	return clientcmd.BuildConfigFromFlags("", *kubeconfig)
}

func main() {
	klog.Info("Let's go anyscheduler!")

	// kubeconfig
	config := LoadConfig()

	// create the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}

	// GpuBestfitPicker
	picker := &GpuBestfitPicker{
		clientset: clientset,
	}

	// Channels
	Q := make(chan *v1.Pod, 100)
	defer close(Q)
	quit := make(chan struct{})
	defer close(quit)

	// Scheduler
	scheduler := NewScheduler(clientset, picker, Q, quit)
	scheduler.Run(quit)
}
