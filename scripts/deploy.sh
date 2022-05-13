#!/bin/bash
#1 chartVersion
#2 acrName
#3 helmChartName
#4 resourceGroup
#5 aksName
#6 subscription
#7 namespace
#8 releaseName
#9 tenantId
#!/bin/bash
set -xe
#login to azure account using service principle
sudo az login --service-principal --username=***** --password=***** --tenant $9
#login to acr and get the latest helm charts available on acr
sudo az acr login -n $2
sudo helm repo remove $2 || true
sudo az acr helm repo add -n $2
sudo helm repo update
sudo helm pull $2/$3 --version $1
sudo tar -xvzf $3-$1.tgz
#get service credentials for AKS
sudo az aks get-credentials --resource-group $4 --name $5 --subscription $6 --admin --overwrite-existing
#helm release
sudo helm upgrade --timeout 5m --namespace $7 --install --wait -f $3/values.yaml $8 $2/$3 --version $1
#cleanup downloaded charts
sudo rm -rf $3 $3-$1.tgz