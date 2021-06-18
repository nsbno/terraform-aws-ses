data "aws_region" "current" {}

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

# Mail Authentication
# ===================
#
# Various authentication methods to verify to other providers that SES is
# allowed to send e-mails on the domains behalf.

# SPF
# ---
#
# Authorize SES to send e-mails on our behalf.
#
# See: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-authentication-spf.html

resource "aws_ses_domain_mail_from" "domain" {
  domain = aws_ses_domain_identity.domain.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.domain.domain}"
}

resource "aws_route53_record" "mail_from" {
  zone_id = data.aws_route53_zone.domain.id
  name    = aws_ses_domain_mail_from.domain.mail_from_domain
  type    = "MX"
  ttl     = "1800"
  records = ["10 feedback-smtp.${data.aws_region.current.name}.amazonses.com"]
}

resource "aws_route53_record" "spf" {
  zone_id = data.aws_route53_zone.domain.id
  type = "TXT"
  ttl = 1800
  name = aws_ses_domain_identity.domain.domain
  records = ["v=spf1 include:amazonses.com ~all"]
}

# DKIM
# ----
#
# Cryptographic signing of e-mails, to allow recipients to verify the sender.
#
# See: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-authentication-dkim.html

resource "aws_ses_domain_dkim" "domain" {
  domain = aws_ses_domain_identity.domain.domain
}

resource "aws_route53_record" "example_amazonses_dkim_record" {
  count   = 3
  zone_id = data.aws_route53_zone.domain.id
  type    = "CNAME"
  ttl     = 1800
  name    = "${element(aws_ses_domain_dkim.domain.dkim_tokens, count.index)}._domainkey"
  records = ["${element(aws_ses_domain_dkim.domain.dkim_tokens, count.index)}.dkim.amazonses.com"]

  depends_on = [aws_ses_domain_dkim.domain]
}

# DMARC
# -----
#
# Barebones DMARC setup.
#
# See: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-authentication-dmarc.html

resource "aws_route53_record" "dmark" {
  zone_id = data.aws_route53_zone.domain.id
  type = "TXT"
  ttl = 1800
  name = "_dmarc.${aws_ses_domain_identity.domain.domain}"
  records = ["v=DMARC1; p=${var.dmarc_policy};"]
}
