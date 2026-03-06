# Search infrastructure & DevSecOps artifacts

Stuff I use for search infra (OpenSearch/Solr), CI/CD, and ops. Terraform for AWS OpenSearch and Azure (Key Vault + storage), GitLab pipeline for building the Solr image, Ansible for rolling restarts, plus a couple scripts for local dev and checking indexes.

- **terraform/opensearch-search** – OpenSearch domain with encryption, VPC, CloudWatch. See `terraform.tfvars.example`; configure S3 backend before apply.
- **terraform/azure-keyvault-storage** – Key Vault + 2 storage accounts (LRS + RA-GRS) using a shared module. Copy `backend.tf.example` to `backend.tf` then run from this dir.
- **gitlab-ci/** – Validates Terraform, builds Solr Docker image, Trivy scan, optional manual deploy to staging. Expects `docker/Dockerfile.solr` at repo root.
- **ansible/solr-zk-rolling-update** – Rolling restart with ZK quorum check, one node at a time. Edit `inventory/hosts.yml` then: `ansible-playbook -i inventory/hosts.yml playbook.yml`.
- **scripts/** – `dev-bootstrap-solr.sh` spins up ZK + Solr in Docker locally. `validate-index-shards.sh` – pass INDEX_NAME and either OPENSEARCH_ENDPOINT or SOLR_URL to check index/collection and doc count.

Terraform 1.3+, Ansible, Docker. For validate script you need curl and jq.
