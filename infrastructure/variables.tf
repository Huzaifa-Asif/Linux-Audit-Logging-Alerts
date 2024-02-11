variable "environment" {
  type        = string
  description = "AWS Environment Name."
  default     = "staging"

  validation {
    condition     = contains(["local", "staging", "production"], var.environment)
    error_message = "Valid values for 'environment' variable are (local, staging, production)."
  }
}

variable "lambda_version" {
  type        = string
  description = "Version of the Lambda function."
  default = "v1.0.0"
  
}