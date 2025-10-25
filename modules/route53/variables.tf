variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for Route53 hosted zone"
  type        = string
}

variable "create_hosted_zone" {
  description = "Create a new hosted zone (false to use existing)"
  type        = bool
  default     = true
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  type        = string
  default     = ""
}

variable "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID"
  type        = string
  default     = ""
}

variable "cloudfront_record_name" {
  description = "Record name for CloudFront distribution"
  type        = string
  default     = ""
}

variable "bastion_public_ip" {
  description = "Bastion host public IP"
  type        = string
  default     = ""
}

variable "custom_records" {
  description = "Map of custom DNS records"
  type = map(object({
    name    = string
    type    = string
    records = list(string)
    ttl     = optional(number)
  }))
  default = {}
}

variable "verification_record" {
  description = "TXT record for domain verification"
  type        = string
  default     = ""
}

variable "caa_records" {
  description = "List of CAA records"
  type        = list(string)
  default     = []
}
