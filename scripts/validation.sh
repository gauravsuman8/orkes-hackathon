acr_name=$2
acr_sub=$3
chart_repo_path=$4
tenant_id=$5

az_dev_sp_id=*****
az_dev_sp_secret=*****

echo "id1 $az_dev_sp_id , p1 $az_dev_sp_secret"
sudo az login --service-principal --username=$az_dev_sp_id --password=$az_dev_sp_secret --tenant $tenant_id
echo "verify chart tag"
echo "chartrepopath: $chart_repo_path"
versions=`sudo az acr helm show -n $acr_name $chart_repo_path | grep "version"`
chart_version_count=`echo "$versions" | grep $chart_tag | wc -l`
chart_version_count_int=`expr $chart_version_count`
echo "$chart_version_count_int"
if [ "$chart_version_count_int" -eq 0 ]; then
  echo "could not verify chart tag $chart_tag"
  echo "List of valid chart tags: "
  echo "$versions"
  exit 1
else
  echo "verified chart tag $chart_tag is valid"
fi
