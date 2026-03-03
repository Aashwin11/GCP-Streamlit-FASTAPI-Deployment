
# 1. SA IAM Identity for the Streamlit Frontend
resource "google_service_account" "frontend_sa" {
  account_id   = "streamlit-frontend-sa"
  display_name = "Identity for Streamlit Frontend when it invokes backend Fastapi"
}

#  SA IAM Identity for the FastAPI Backend
resource "google_service_account" "backend_sa" {
  account_id   = "fastapi-backend-sa"
  display_name = "Identity for the FastAPI Backend"
}

# 2. Deploy the FastAPI Backend (No internet Access)
module "backend_api" {
  source                = "./modules/cloud_run"
  project_id            = var.project_id
  region                = var.region
  service_name          = "fastapi-backend"
  image                 = "${var.region}-docker.pkg.dev/${var.project_id}/demo-project-fastapi-backend-repo/fastapi:latest"
  allow_unauthenticated = false # LOCKED DOWN (No Internert Access)
  service_account_email = google_service_account.backend_sa.email
}

# 3. Communication between Frontend and Backend using Invoker, 
# assigning Service account the invoker role
resource "google_cloud_run_service_iam_member" "backend_invoker" {
  project  = var.project_id
  location = var.region
  service  = module.backend_api.service_name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.frontend_sa.email}"
}

# 4. Deploy the Streamlit Frontend (Public)
module "frontend_ui" {
  source                = "./modules/cloud_run"
  project_id            = var.project_id
  region                = var.region
  service_name          = "streamlit-frontend"
  image                 = "${var.region}-docker.pkg.dev/${var.project_id}/demo-project-streamlit-frontend-repo/streamlit:latest"
  allow_unauthenticated = true # PUBLIC , Internet facing
  service_account_email = google_service_account.frontend_sa.email
  
  # Fill the Backend URL dynamically
  env_vars = {
    BACKEND_URL = module.backend_api.service_url
  }
}