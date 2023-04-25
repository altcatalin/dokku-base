terraform {
  required_version = "~> 1.4"

  backend "gcs" {}

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.38"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.4"
    }

    http = {
      version = "~>3.2"
    }
  }
}

provider "hcloud" {}
provider "cloudflare" {}
