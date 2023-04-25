variable "project" {
  description = "Project name."
  type        = string
  default     = "dokku"
}

variable "ssh_user" {
  description = "SSH user and public keys. Example: `{\"user\": \"altcatalin\", \"keys\": [\"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKvI3qbFBHqVWYaIQMcf4cNxswaLqD1pQG8TUmko3Lii\"]}`"

  type = object({
    user : string
    keys : list(string)
  })
}

variable "ssh_allow_ipv4" {
  description = "Allow SSH access from specific IPv4 addresses (CIDR notation). Example: `[\"89.238.215.238/32\"]`"
  type        = list(string)
}

variable "server_type" {
  description = "Server type."
  type        = string
  default     = "cx21"
}

variable "server_image" {
  description = "Server image."
  type        = string
  default     = "ubuntu-20.04"
}

variable "server_datacenter" {
  description = "Server datacenter."
  type        = string
  default     = "fsn1-dc14"
}

variable "dokku_apps_domains" {
  description = ""
  type        = list(string)
  default     = []
}
