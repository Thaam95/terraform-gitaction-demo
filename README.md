# AWS Terraform + GitHub Actions POC

A small repository for demonstrating how a request can trigger Terraform through GitHub Actions.

## What this creates

- 1 VPC
- 2 public subnets across two Availability Zones
- 2 private subnets across two Availability Zones
- 1 Internet Gateway
- Public and private route tables
- 1 Security Group (AWS equivalent of an NSG)
- Public and private Network ACLs

It deliberately does **not** create EC2, NAT Gateway, Load Balancer, Elastic IP, RDS, or other resources with hourly service charges.

> AWS can still charge for data transfer or other account activity. Always review the plan before applying.

## Repository structure

```text
.
├── .github/workflows/
│   ├── terraform-check.yml   # fmt, validate, and plan
│   └── terraform-demo.yml    # temporary apply, wait, and automatic destroy
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── versions.tf
│   └── terraform.tfvars.example
└── README.md
```

## Local demo

Prerequisites: Terraform CLI, AWS CLI, and an AWS identity with permission to manage VPC networking.

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
terraform output
terraform destroy
```

## GitHub Actions authentication

The workflows use GitHub OIDC, so long-lived AWS access keys are not required.

1. Create an AWS IAM OIDC provider for `token.actions.githubusercontent.com`.
2. Create an IAM role trusted only by your GitHub organization/repository.
3. Give the role permissions to manage the POC VPC resources.
4. Add the role ARN as a GitHub repository secret named `AWS_ROLE_ARN`.
5. Create a GitHub Environment named `poc` and optionally configure a required reviewer.

Example trust-policy condition:

```json
{
  "StringEquals": {
    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
  },
  "StringLike": {
    "token.actions.githubusercontent.com:sub": "repo:YOUR_ORG/YOUR_REPO:*"
  }
}
```

For a tighter production policy, restrict the subject to the intended branch or GitHub Environment.

## Demo flow

1. Open **Actions** in GitHub.
2. Select **Terraform Temporary Demo**.
3. Select **Run workflow**.
4. The job runs plan and apply, prints Terraform outputs, waits for the selected period, and then destroys all resources.
5. The destroy step uses `if: always()` so it also runs when a later demo step fails.

This create-and-destroy-in-one-run approach keeps the POC simple and avoids requiring a paid or persistent Terraform state backend.

## Suggested talking points

- Git is the source of truth for infrastructure code.
- Pull requests run formatting, validation, and a Terraform plan.
- GitHub OIDC provides short-lived AWS credentials.
- A protected GitHub Environment can act as an approval gate.
- Terraform creates consistent resources and automatically tears them down after the demo.
# terraform-gitaction-demo
