# hetzner
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.4 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | ~> 1.38 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~>3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 4.4.0 |
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.38.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_record.dokku](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [hcloud_firewall.dokku](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall) | resource |
| [hcloud_primary_ip.dokku](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/primary_ip) | resource |
| [hcloud_server.dokku](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |
| [hcloud_ssh_key.dokku](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key) | resource |
| [cloudflare_ip_ranges.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/ip_ranges) | data source |
| [cloudflare_zone.dokku](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dokku_apps_domains"></a> [dokku\_apps\_domains](#input\_dokku\_apps\_domains) | n/a | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name. | `string` | `"dokku"` | no |
| <a name="input_server_datacenter"></a> [server\_datacenter](#input\_server\_datacenter) | Server datacenter. | `string` | `"fsn1-dc14"` | no |
| <a name="input_server_image"></a> [server\_image](#input\_server\_image) | Server image. | `string` | `"ubuntu-20.04"` | no |
| <a name="input_server_type"></a> [server\_type](#input\_server\_type) | Server type. | `string` | `"cx21"` | no |
| <a name="input_ssh_allow_ipv4"></a> [ssh\_allow\_ipv4](#input\_ssh\_allow\_ipv4) | Allow SSH access from specific IPv4 addresses (CIDR notation). Example: `["89.238.215.238/32"]` | `list(string)` | n/a | yes |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | SSH user and public keys. Example: `{"user": "altcatalin", "keys": ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKvI3qbFBHqVWYaIQMcf4cNxswaLqD1pQG8TUmko3Lii"]}` | <pre>object({<br>    user : string<br>    keys : list(string)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_server_ip"></a> [server\_ip](#output\_server\_ip) | n/a |
| <a name="output_server_name"></a> [server\_name](#output\_server\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
