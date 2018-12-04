FROM consul:latest
FROM envoyproxy/envoy:v1.8.0
COPY --from=0 /bin/consul /bin/consul
ENTRYPOINT ["dumb-init", "consul", "connect", "envoy"]