# GreenMail on Kubernetes via Terraform

Example for running [GreenMail](https://greenmail-mail-test.github.io/greenmail/) containerized on k8s via
[Terraform Kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs).

## Quickstart

1. Optionally start local [Minikube](https://minikube.sigs.k8s.io/docs/)

    An easy way to test the setup is to use a local Minikube k8s cluster, e.g. via
    ```
    minikube start --extra-config=apiserver.service-node-port-range=1025-9999  
    ```
   
2. Initialize terraform (once only, downloads k8s provider etc.)
    ```
    terraform init // Once only for TF setup
    ```
   
3. Create GreenMail k8s namespace, pod and service example

    Optionally reconfigure k8s namespace and service port mappings in [main.tf](main.tf).
    
    ```
    terraform apply // Creates POD with GreenMail container and service
    kubectl describe pods tf-pod-greenmail --namespace tf-ns-greenmail
    kubectl describe services tf-service-greenmail --namespace tf-ns-greenmail
    kubectl logs --namespace tf-ns-greenmail tf-pod-greenmail // Get GreenMail log output
    minikube service list  // Get local, external IP of GreenMail
    ```
    As a smoke test you can e.g. invoke the GreenMail API (defaults to port 8080) or configure your favorite mail client.

5. Cleanup
    ```
    terraform destroy // Removed GreenMail namespace, pod and service example
    minikube stop
    ```
