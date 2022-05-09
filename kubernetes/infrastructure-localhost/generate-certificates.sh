STORAGE=certificates
rm -R $STORAGE
mkdir -p $STORAGE

ROOT_CA_KEY_NAME=$STORAGE/root-ca-key.pem
ROOT_CA_NAME=$STORAGE/root-ca.pem

openssl genrsa -out $ROOT_CA_KEY_NAME 2048
openssl req -x509 -new -sha256 -key $ROOT_CA_KEY_NAME -out $ROOT_CA_NAME -days 730 -subj "/C=DE/L=PROD/O=PROD/OU=SSL/CN=ROOT"

# Admin cert
openssl genrsa -out $STORAGE/admin-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in $STORAGE/admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out $STORAGE/admin-key.pem
openssl req -new -key $STORAGE/admin-key.pem -subj "/C=DE/L=PROD/O=PROD/OU=SSL/CN=ADMIN" -out $STORAGE/admin.csr
openssl x509 -req -in $STORAGE/admin.csr -CA $ROOT_CA_NAME -CAkey $ROOT_CA_KEY_NAME -CAcreateserial -sha256 -out $STORAGE/admin.pem -days 730

# Optional use-cases
# Node certificates
NODENAME=opensearch-node
STORAGE_NODENAME=$STORAGE/$NODENAME

openssl genrsa -out $STORAGE_NODENAME-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in $STORAGE_NODENAME-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out $STORAGE_NODENAME-key.pem
openssl req -new -key $STORAGE_NODENAME-key.pem -subj "/C=DE/L=PROD/O=PROD/OU=SSL/CN=$NODENAME.doitsu.tech" -out $STORAGE_NODENAME.csr
openssl x509 -req -in $STORAGE_NODENAME.csr -CA $ROOT_CA_NAME -CAkey $ROOT_CA_KEY_NAME -CAcreateserial -sha256 -out $STORAGE_NODENAME.pem -days 730

# Client cert
openssl genrsa -out $STORAGE/client-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in $STORAGE/client-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out $STORAGE/client-key.pem
openssl req -new -key $STORAGE/client-key.pem -subj "/C=DE/L=PROD/O=PROD/OU=SSL/CN=CLIENT" -out $STORAGE/client.csr
openssl x509 -req -in $STORAGE/client.csr -CA $ROOT_CA_NAME -CAkey $ROOT_CA_KEY_NAME -CAcreateserial -sha256 -out $STORAGE/client.pem -days 730
