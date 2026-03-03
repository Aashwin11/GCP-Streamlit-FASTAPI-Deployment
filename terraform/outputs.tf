output "frontend_public_url" {
  description = "The public URL to access the Streamlit AI Agent UI"
  value       = module.frontend_ui.service_url
}

output "backend_internal_url" {
  description = "The locked-down internal URL of the FastAPI backend"
  value       = module.backend_api.service_url
}

output "frontend_service_account_email" {
  description = "The Service Account email used by the frontend for authentication"
  value       = google_service_account.frontend_sa.email
}