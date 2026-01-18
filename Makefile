.PHONY: init plan apply destroy fmt validate lint clean

init:
	tofu init

plan:
	tofu plan

apply:
	tofu apply -auto-approve

destroy:
	tofu destroy -auto-approve

fmt:
	tofu fmt -recursive

validate:
	tofu validate

lint:
	flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
	flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

clean:
	find . -name "*.zip" -delete
	rm -rf .terraform/
	rm -f terraform.tfstate*
