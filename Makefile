.ONESHELL:
.PHONY: build-ami deploy-ami plan apply destroy graph clean

-include env.mk
-include bootstrap_tmp.mk

update:
	@terraform get ./terraform

bootstrap_tmp.mk:
	@bash bootstrap.sh > bootstrap_tmp.mk

build-ami:
	@packer build packer/wp.json 2>&1 | tee .packer-out.log
	@$(MAKE) clean

deploy-ami:
	@bash deploy_ami.sh

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
	@rm -rf ./bootstrap_tmp.mk
