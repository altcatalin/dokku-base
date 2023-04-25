terraform {
  source = "../../..//modules/hetzner"
}

include {
  path = find_in_parent_folders()
}
