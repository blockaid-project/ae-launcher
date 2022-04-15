if [ ! -f "$CREDENTIALS_FILE" ]
then
  echo "AWS credentials not found..."
  read -r -p 'AWS Access Key ID: ' access_key_id
  read -r -p 'AWS Secret Access Key: ' secret_access_key
  read -r -p 'AWS region [default: us-east-2]: ' region
  region=${region:-us-east-2}
  read -r -p 'EC2 AMI ID [default: ami-01457e9b6b7cdee4e]: ' ami_id
  ami_id=${ami_id:-ami-01457e9b6b7cdee4e}

tee "$CREDENTIALS_FILE" <<EOF >/dev/null
export AWS_REGION=${region}
export AWS_ACCESS_KEY=${access_key_id}
export AWS_SECRET_KEY=${secret_access_key}
export AMI_ID=${ami_id}
EOF
fi
source "$CREDENTIALS_FILE"
