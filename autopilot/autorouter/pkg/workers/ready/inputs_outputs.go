// Code generated by Autopilot. DO NOT EDIT.

package ready

import (
	parameters "autorouter.example.io/pkg/parameters"
)

type Inputs struct {
	Deployments parameters.Deployments
}

// FindDeployment returns <Deployment, true> if the item is found. else parameters.Deployment{}, false
func (i Inputs) FindDeployment(name, namespace string) (parameters.Deployment, bool) {
	for _, item := range i.Deployments.Items {
		if item.Name == name && item.Namespace == namespace {
			return item, true
		}
	}
	return parameters.Deployment{}, false
}
