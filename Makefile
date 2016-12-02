.PHONY: build-ami deploy-ami plan apply destroy graph clean

-include .mikado.conf.mk
-include .aws_data.mk

.mikado.conf.mk:
	@cat mikado.conf | sed 's/"//g ; s/=/:=/' > .mikado.conf.mk

.aws_data.mk:
	@bash ./scripts/aws_data.sh | sed 's/"//g ; s/=/:=/' > .aws_data.mk

update:
	@terraform get ./terraform

build-ami:
	@packer build packer/wp.json 2>&1 | tee .packer-out.log
	@$(MAKE) clean

deploy-ami:
	@bash ./scripts/deploy_ami.sh
	@$(MAKE) clean

# This target executes the terraform plan stage
# This will not change anything in you AWS setup only displays the changes
plan: update
	@terraform plan \
		-out ./.tfplan \
		./terraform

# Once you happy with the output of make plan run this target
# This will change your remote resources
apply: plan
	@while [ -z "$$CONTINUE" ]; do \
	    read -r -p "Dow you want to apply these changes? [y/N] " CONTINUE; \
	done ; \
	if [ ! $$CONTINUE == "y" ]; then \
	if [ ! $$CONTINUE == "Y" ]; then \
	    echo "Exiting." ; exit 1 ; \
	fi \
	fi
	@terraform apply \
		./terraform
	@$(MAKE) -s clean

graph: update
	@terraform graph \
		-draw-cycles ./terraform | dot -Tpng > graph.png
	@$(MAKE) -s clean

# Don't run this
destroy: update
	@terraform plan -destroy -out ./terraform.tfplan ./terraform/
	@terraform apply ./terraform.tfplan
	@$(MAKE) -s clean

clean:
	@rm -rf ./.tmp
	@rm -rf ./.terraform
	@rm -f ./.mikado.conf.mk
	@rm -f ./.aws_data.mk
