#! /bin/bash -e
set -x

F=$1
TF_URLS=$2
TF_USERNAME=$3
TF_PASSWORD=$4
CONTAINERS=$5

util/telegraf/usr/bin/telegraf -sample-config -input-filter 'cpu:docker' -output-filter 'influxdb' > ${F}
sed -i "s/debug = false/debug = true/g" ${F}
#sed -i "s/quiet = false/quiet = true/g" ${F}
sed -i "s/urls = .*/urls = \[\"${TF_URLS}\"\]/g" ${F}
sed -i "s/[#] username = .*/username = \"${TF_USERNAME}\"/g" ${F}
sed -i "s/[#] password = .*/password = \"${TF_PASSWORD}\"/g" ${F}
sed -i "s/percpu = true/percpu = false/g" ${F}
sed -i "s/container_names = .*/container_names = \[${CONTAINERS}\]/g" ${F}

exec util/telegraf/usr/bin/telegraf -config ${F}
