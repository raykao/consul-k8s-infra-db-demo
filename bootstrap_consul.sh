# get cluster node IPs


# Bootsrap server command
sudo consul agent \
  -config-dir=/etc/consul.d \
  -data-dir=/opt/consul \
  -datacenter=canada-central \
  -advertise=192.168.0.5 \
  -bind=192.168.0.5 \
  -client=127.0.0.1 \
  -bootstrap-expect=3 \
  -ui \
  -retry-join=192.168.0.4 \
  -retry-join=192.168.0.5 \
  -retry-join=192.168.0.6 \
  -syslog=true \
  -server