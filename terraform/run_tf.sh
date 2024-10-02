echo "Initializing Terraform..."
terraform init

# Create a plan
echo "Creating Terraform plan..."
terraform plan -var-file="terraform.tfvars" -out=tfplan

# Apply the plan
echo "Applying Terraform plan..."
terraform apply tfplan

# Clean up the plan file
rm tfplan
