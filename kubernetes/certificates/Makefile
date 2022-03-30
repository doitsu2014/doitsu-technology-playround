default: test

# include ../../../helpers/examples.mk
STACK_VERSION := 7.17.2-SNAPSHOT 

# RELEASE := helm-es-security
# TIMEOUT := 1200s
ELASTICSEARCH_IMAGE := elasticsearch:8.1.1
ELASTIC_PASSWORD := zaQ@1234

secrets:
	docker rm -f elastic-helm-charts-certs || true
	rm -f elastic-certificates.p12 elastic-certificate.pem elastic-certificate.crt elastic-stack-ca.p12 || true
	password=$$([ ! -z "$(ELASTIC_PASSWORD)" ] && echo $(ELASTIC_PASSWORD) || echo $$(docker run --rm busybox:1.31.1 /bin/sh -c "< /dev/urandom tr -cd '[:alnum:]' | head -c20")) && \
	docker run --name elastic-helm-charts-certs -i -w /app \
		$(ELASTICSEARCH_IMAGE) \
		/bin/sh -c " \
			elasticsearch-certutil ca --out /app/elastic-stack-ca.p12 --pass '' && \
			elasticsearch-certutil cert --name security-master --dns security-master --ca /app/elastic-stack-ca.p12 --pass '' --ca-pass '' --out /app/elastic-certificates.p12" && \
	docker cp elastic-helm-charts-certs:/app/elastic-certificates.p12 ./ && \
	docker rm -f elastic-helm-charts-certs 
	# && \
	# openssl pkcs12 -nodes -passin pass:'' -in elastic-certificates.p12 -out elastic-certificate.pem && \
	# openssl x509 -outform der -in elastic-certificate.pem -out elastic-certificate.crt && \
	# kubectl create secret generic elastic-certificates --from-file=elastic-certificates.p12 && \
	# kubectl create secret generic elastic-certificate-pem --from-file=elastic-certificate.pem && \
	# kubectl create secret generic elastic-certificate-crt --from-file=elastic-certificate.crt && \
	# kubectl create secret generic elastic-credentials --from-literal=password=$$password --from-literal=username=elastic && \
	# rm -f elastic-certificates.p12 elastic-certificate.pem elastic-certificate.crt elastic-stack-ca.p12
