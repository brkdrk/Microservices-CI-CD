PATH="$PATH:/usr/local/bin"
APP_NAME="petclinic"
ANS_KEYPAIR="matt-${APP_NAME}-qa.key"
AWS_REGION="eu-central-1"
cd infrastructure/qa-k8s-terraform
terraform init
terraform apply -auto-approve -no-color