resource "google_cloud_run_v2_service" "default" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    service_account = var.service_account_email != "" ? var.service_account_email : null
    
    containers {
      image = var.image

      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }
}

# The GCP Bouncer-> Controls who can access the service
resource "google_cloud_run_service_iam_member" "invoker" {
  count    = var.allow_unauthenticated ? 1 : 0
  project  = var.project_id
  location = google_cloud_run_v2_service.default.location
  service  = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers" # Opens to the public internet
}