output "domain_name" {
  value       = aws_opensearch_domain.search.domain_name
  description = "OpenSearch domain name"
}

output "domain_endpoint" {
  value       = aws_opensearch_domain.search.endpoint
  description = "OpenSearch endpoint (use with https)"
}

output "domain_arn" {
  value = aws_opensearch_domain.search.arn
}

output "security_group_id" {
  value = aws_security_group.opensearch.id
}
