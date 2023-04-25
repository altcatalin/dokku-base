remote_state {
  backend = "gcs"

  config = {
    project  = get_env("GCP_PROJECT_ID")
    location = "us" # free

    bucket = "tfstate-${get_env("GCP_PROJECT_ID")}"
    prefix = path_relative_to_include()
  }
}
