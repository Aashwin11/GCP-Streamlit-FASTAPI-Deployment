variable "project_id" { 
    type = string 
    }
variable "region" { 
    type = string 
}
variable "service_name" { 
    type = string 
    }
variable "image" { 
    type = string 
    }
variable "allow_unauthenticated" { 
  type = bool 
  description = "If true, open to public. If false, locked down."
}
variable "service_account_email" { 
  type = string 
  default = "" 
  description = "The identity the container runs as"
}
variable "env_vars" {
  type = map(string)
  default = {}
}