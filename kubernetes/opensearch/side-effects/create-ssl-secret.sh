CERT_NAME=secret-tls
KEY_FILE=../certificates/key_file.pem
CERT_FILE=../certificates/cert_file.pem

kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}