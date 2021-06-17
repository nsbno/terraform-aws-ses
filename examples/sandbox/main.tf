terraform {
  required_version = "1.0.0"
}

provider "aws" {
  region = "eu-west-1"
}

module "ses" {
  source = "../../"

  domain_name = "test.infrademo.vydev.io"
}

# This will be the only e-mail that this instance of SES can send to outside of
# the domain name specified above.
resource "aws_ses_email_identity" "personal" {
  email = "nicolas.harlem.eide@vy.no"
}
