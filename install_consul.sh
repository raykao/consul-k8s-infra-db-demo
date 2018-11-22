#!/bin/bash

# Terraform variables will be "injected" via interpolation and data source configuration in main template

# Used for setting up Consul Server inter-node encrpyted settings
CONSUL_ENCRYPT="${consul_encrpyt}"
CONSUL_DATACENTER="${consul_datacenter}"

# Used for getting cluster IP addresses for Consul bootstrapping/join
AZURE_SCALE_SET_NAME="${scale_set_name}"
AZURE_SUBSCRIPTION_ID="${subscription_id}"
AZURE_TENENT_ID="${tenant_id}"
AZURE_CLIENT_ID="${client_id}"
AZURE_SECRET_ACCESS_KEY="${secret_access_key}"

apt update

apt install -y unzip jq

cd /tmp

wget https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip

unzip consul_1.4.0_linux_amd64.zip

chown root:root consul

mv consul /usr/local/bin/

consul -autocomplete-install
complete -C /usr/local/bin/consul consul

useradd --system --home /etc/consul.d --shell /bin/false consul
mkdir --parents /opt/consul
chown --recursive consul:consul /opt/consul

touch /etc/systemd/system/consul.service

cat >/etc/systemd/system/consul.service <<EOF
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/local/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

mkdir --parents /etc/consul.d
touch /etc/consul.d/consul.hcl
chown --recursive consul:consul /etc/consul.d
chmod 640 /etc/consul.d/consul.hcl

cat >/etc/consul.d/consul.hcl <<EOF
datacenter = "dc1"
data_dir = "/opt/consul"
encrypt = "$CONSUL_ENCRYPT"
EOF