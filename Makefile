tfvars:
	@echo "copying tfvars to subdirs"
	cp terraform.tfvars eks-demo
	cp terraform.tfvars ec2-demo
