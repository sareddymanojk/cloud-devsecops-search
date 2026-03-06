

- **terraform/opensearch-search** – OpenSearch domain with encryption, VPC, CloudWatch. See `terraform.tfvars.example`; configure S3 backend before apply.
- **terraform/azure-keyvault-storage** – Key Vault + 2 storage accounts (LRS + RA-GRS) using a shared module.
- **gitlab-ci/** – Validates Terraform, builds Solr Docker image, Trivy scan, manual deploy to staging. `docker/Dockerfile.solr` at repo root.
- **ansible/solr-zk-rolling-update** – Rolling restart with ZK quorum check, one node at a time. Edit `inventory/hosts.yml` then: `ansible-playbook -i inventory/hosts.yml playbook.yml`.
- **scripts/** – `dev-bootstrap-solr.sh` spins up ZK + Solr in Docker . `validate-index-shards.sh` – pass INDEX_NAME and either OPENSEARCH_ENDPOINT or SOLR_URL to check index/collection and doc count.

