FROM alpine:3.7

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

COPY root /

RUN apk add openvpn=2.4.12-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.12/main/
RUN apk add --update --no-cache tinyproxy \
	&& mkdir config \
	&& wget https://www.ipvanish.com/software/configs/configs.zip -P config/ \
	&& unzip config/configs.zip -d config \
	&& mv config/ca.ipvanish.com.crt . \
	&& chmod 755 tls-verify.sh \
	&& chmod 755 connect.sh \
	&& sed -i 's/Allow /#Allow /g' /etc/tinyproxy/tinyproxy.conf \
	&& sed -i 's/#DisableViaHeader /DisableViaHeader /g' /etc/tinyproxy/tinyproxy.conf

ENV COUNTRY='NL' \
	USERNAME='' \
	PASSWORD='' \
	PNET='' \
	RANDOMIZE='true' \
	PRIO_REMOTE=''

EXPOSE 8888

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s \  
 CMD /bin/sh /app/healthcheck.sh

ENTRYPOINT [ "/app/connect.sh" ]
