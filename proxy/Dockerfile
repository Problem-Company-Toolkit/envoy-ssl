ARG BASE_IMAGE="envoyproxy/envoy:v1.23.1"
FROM ${BASE_IMAGE}

RUN \
  apt update -y \
  && apt install -y python-pip \
  && pip install jinja2

COPY envoy.http.template.yaml /tmp/envoy.http.template.yaml
COPY envoy.https.template.yaml /tmp/envoy.https.template.yaml

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]