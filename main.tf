data "aws_route53_zone" "domain" {
  name = var.domain_name
}


# SES Domain Verification
# =======================
#
# Allows SES to send from any address on the specific domain

resource "aws_ses_domain_identity" "domain" {
  domain = var.domain_name
}

resource "aws_ses_domain_identity_verification" "domain" {
  domain = aws_ses_domain_identity.domain.id

  depends_on = [aws_route53_record.domain_identification]
}

resource "aws_route53_record" "domain_identification" {
  name = "_amazonses.${aws_ses_domain_identity.domain.id}"
  zone_id = data.aws_route53_zone.domain.zone_id
  type = "TXT"
  ttl = 1800
  records = [aws_ses_domain_identity.domain.verification_token]
}
