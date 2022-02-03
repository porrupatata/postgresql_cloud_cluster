CONF_FILE=cluster_conf.yml
cluster_name=$(egrep '^cluster_name:' $CONF_FILE |sed 's/cluster_name:\s*//g'|sed $'s/\'//g')
instance_name_raw=$(egrep '^instance_name:' $CONF_FILE |sed 's/instance_name:\s*//g'|sed $'s/\"//g')
instance_name=$(echo $instance_name_raw|sed "s/{{ cluster_name }}/$cluster_name/")

if [ ! -z "$1" ]; then
        instance_name=$1
fi
echo "stopping $instance_name"

aws ec2 describe-instances  --filters  Name=instance-state-name,Values=running Name=tag:Name,Values="$instance_name"*  --output text --query 'Reservations[*].Instances[*].InstanceId' |sed -e 's/[[:space:]]\+/\n/g' |xargs aws ec2 stop-instances --instance-ids
