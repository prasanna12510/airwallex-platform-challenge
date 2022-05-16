## NginxIngress using Terraform

### Install
```shell
terraform apply
```

### Post Install
```shell
#patch pod with annotations
kubectl patch pod/ingress-nginx-controller  --type='json' -p='[{"op": "add", "path": "/metadata/annotations/prometheus.io~1port", "value":"10254"}, {"op": "add", "path": "/metadata/annotations/prometheus.io~1scrape", "value":"true"}]'
```
