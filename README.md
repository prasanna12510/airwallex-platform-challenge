# Airwallex Platform Challenge

## Infra
Deployed infrastructure stack including nginx and prometheus for exposing external API and monitoring the requests

#### AWS Production Grade Architecture

![Alt text](https://github.com/prasanna12510/airwallex-platform-challenge/blob/main/docs/img/APIArchicture.png?raw=true "AWSArchitecture")

### Prerequisite:
1. s3 bucket for state management
2. IAM ROLE for terraform aws provider via assume role

### Terragrunt Apply and Destroy:
```shell
export TF_VAR_env_deployment='aws-demo' (it will retrieve the correct config based on type of environment)
terragrunt apply (to create infrastructure stack)
terragrunt destroy (to destroy infrastructure stack)

```

### NGINX Webserver
![Alt text](https://github.com/prasanna12510/airwallex-platform-challenge/blob/main/docs/img/nginx-webserver.png?raw=true "AWSArchitecture")


##Service

1. Access the k8s cluster
```shell
aws eks --region ap-southeast-1 update-kubeconfig --name aws-demo
```
2. deploy service using skaffold
```shell
cd service/words-counter/deploy
export IMAGE_TAG=v1.0.0
skaffold deploy -t $IMAGE_TAG
```
3. API Output
``` shell
kubectl get service -n nginx-ingress

##retrieve the LB external URL to access the service API endpoint
```
![Alt text](https://github.com/prasanna12510/airwallex-platform-challenge/blob/main/docs/img/word-frequency.png?raw=true "AWSArchitecture")

## Monitoring output
1. Analyze promql on grafana dashboard
![Alt text](https://github.com/prasanna12510/hyphen-platform-challenge/blob/main/doc/img/metrics-grafana.png?raw=true "Grafana")

2. Ingress Monitoring
![Alt text](https://github.com/prasanna12510/hyphen-platform-challenge/blob/main/doc/img/ingress-monitoring.png?raw=true "Ingress Monitoring")

3. Cluster Monitoring
![Alt text](https://github.com/prasanna12510/hyphen-platform-challenge/blob/main/doc/img/clusterdetail.png?raw=true "K8s Cluster Monitoring")
