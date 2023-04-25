locals {
  project     = replace(var.project, "/[^a-z0-9-_]/", "")
  server_name = replace("${local.project}-${var.server_image}-${var.server_datacenter}", "/[^a-z0-9-_]/", "")

  ssh_keys = { for key in var.ssh_user.keys : "${var.ssh_user.user}:sha256:${sha256(key)}" => key }

  dokku_apps_domains = { for domain in var.dokku_apps_domains : domain => regex("[^\\.]+.[^\\.]+$", domain) }
}

###
### Hetzner
###

resource "hcloud_ssh_key" "dokku" {
  for_each = local.ssh_keys

  name       = each.key
  public_key = each.value
}

resource "hcloud_primary_ip" "dokku" {
  name          = local.project
  datacenter    = var.server_datacenter
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
}

data "cloudflare_ip_ranges" "this" {}

resource "hcloud_firewall" "dokku" {
  name = local.project

  rule {
    direction = "in"
    protocol  = "icmp"

    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  dynamic "rule" {
    for_each = length(var.ssh_allow_ipv4) > 0 ? toset(["ssh"]) : toset([])

    content {
      direction = "in"
      protocol  = "tcp"
      port      = "22"

      source_ips = var.ssh_allow_ipv4
    }
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"

    source_ips = data.cloudflare_ip_ranges.this.ipv4_cidr_blocks
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"

    source_ips = data.cloudflare_ip_ranges.this.ipv4_cidr_blocks
  }
}

resource "hcloud_server" "dokku" {
  name         = local.server_name
  image        = var.server_image
  server_type  = var.server_type
  datacenter   = var.server_datacenter
  ssh_keys     = values(hcloud_ssh_key.dokku).*.id
  firewall_ids = [hcloud_firewall.dokku.id]

  user_data = templatefile("${path.module}/user_data.tftpl", {
    ssh_user = var.ssh_user
  })

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.dokku.id
    ipv6_enabled = false
  }

  labels = {
    project = local.project
  }
}

###
### Cloudflare
###

data "cloudflare_zone" "dokku" {
  for_each = toset(distinct(values(local.dokku_apps_domains)))

  name = each.value
}

resource "cloudflare_record" "dokku" {
  for_each = local.dokku_apps_domains

  zone_id = data.cloudflare_zone.dokku[each.value].zone_id
  name    = replace(each.key, each.value, "")
  value   = hcloud_primary_ip.dokku.ip_address
  type    = "A"
  proxied = true
}
