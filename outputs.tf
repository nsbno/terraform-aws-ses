output "domain_identity_arn" {
  description = "The domain identity's ARN"
  value       = aws_ses_domain_identity.domain.arn
}
