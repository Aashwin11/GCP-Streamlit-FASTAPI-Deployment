variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the resources"
  type        = string
  default     = "us-east1"
}