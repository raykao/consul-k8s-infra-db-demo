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