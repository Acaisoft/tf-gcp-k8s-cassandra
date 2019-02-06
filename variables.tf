# Parameters authorized:
# version (default: v2.9.1)
# values (default: values.yaml)
variable "helm" {
  type        = "map"
  description = "Helm provider parameters"
  default     = {}
}

# Parameters authorized:
# credentials_path (mandatory)
# project (mandatory)
# region (mandatory)
variable "provider" {
  type        = "map"
  description = "Google provider parameters"
}

# Parameters authorized:
# bucket (mandatory)
# prefix (mandatory)
variable "gke_cluster_remote_state" {
  type        = "map"
  description = "GKE cluster remote state parameters"
}