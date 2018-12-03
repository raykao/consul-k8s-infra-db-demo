- add to /etc/systemd/resolved.conf
```
DNS=127.0.0.1
Domains=~consul
```

- add forwarding of port 53 to 8600
```
iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600
iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600
```


echo '{"service": {"name": "web", "tags": ["node"], "port": 80}}' > ./web.json

echo '{"service": {"name": "mysql", "tags": ["master"], "port": 3306}}' > ./mysql.json

{
  "name": "mysql-sidecar-proxy",
  "port": 20000,
  "kind": "connect-proxy",
  "proxy": {
    "destination_service_name": "mysql",
    "destination_service_id": "mysql",
    "local_service_address": "127.0.0.1",
    "local_service_port": 3306,
  }
}

{
  "name": "web-sidecar-proxy",
  "port": 20001,
  "kind": "connect-proxy",
  "proxy": {
    "destination_service_name": "web",
    "destination_service_id": "web",
    "local_service_address": "127.0.0.1",
    "local_service_port": 3000,
  }
}

{
  "name": "web",
  "port": 8080,
  "connect": {
    "sidecar_service": {
      "proxy": {
        "upstreams": [
          {
            "destination_name": "db",
            "local_bind_port": 9191
          }
        ],
        "config": {
          "handshake_timeout_ms": 1000
        }
      }
    }
  }
}