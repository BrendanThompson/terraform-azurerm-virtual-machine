.PHONY: unit integration validate all terraform_init docs

all: validate unit integration precheck docs

terraform_init:
	@terraform init -upgrade

unit: terraform_init
	@terraform test $$(find tests -name "unit_*" -maxdepth 1 -type f -not -path '*/\.*' | sed -e 's/^/--filter=/' | tr '\n' ' ')

integration: terraform_init
	@terraform test $$(find tests -name "integration_*" -maxdepth 1 -type f -not -path '*/\.*' | sed -e 's/^/--filter=/' | tr '\n' ' ')

validate: terraform_init
	@terraform test $$(find tests -name "validate_*" -maxdepth 1 -type f -not -path '*/\.*' | sed -e 's/^/--filter=/' | tr '\n' ' ')

precheck: terraform_init
	@terraform test --filter=tests/pre_validation_coverage.tftest.hcl

docs:
	@terraform-docs -c .terraform-docs.yml .
