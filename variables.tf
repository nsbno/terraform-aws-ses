variable "domain_name" {
  type = string
  description = "The domain name to register SES to"
}

variable "dmarc_policy" {
  type = string
  description = "What should recipients do with emails that don't pass authentication?"
  default = "quarantine"  # Spam-folder
}
