tfvars:
	@echo "copying tfvars to subdirs"
	cp terraform.tfvars eks-demo
	cp terraform.tfvars ec2-demo
	cp terraform.tfvars lambda-demo
	cp terraform.tfvars s3-demo
