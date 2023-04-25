# dokku-base

Base [Dokku](https://dokku.com/) setup on different hosting providers, with [Terraform](https://www.terraform.io/) and [Ansible](https://www.ansible.com/).

## Prerequisites

This project works on the assumption that you already have:
* a [Cloudflare account](https://www.cloudflare.com/) and a domain with DNS managed from Cloudflare.
* a [GCP account](https://cloud.google.com/gcp). A Cloud Storage bucket will be created automatically and used to store the [Terraform state](https://developer.hashicorp.com/terraform/language/settings/backends/gcs), at no cost.

The following tools must be installed on your local machine:
  * [pipenv](https://pipenv.pypa.io/en/latest/)
  * [gcloud](https://cloud.google.com/sdk/gcloud)
  * [terraform](https://www.terraform.io/)
  * [terragrunt](https://terragrunt.gruntwork.io/)
  * [dokku](https://dokku.com/docs/deployment/remote-commands/)
  * (optional) [pre-commit](https://pre-commit.com/)

All commands will be executed in a virtual environment created with **pipenv**. This workflow has been tested on **macOS v13**, some tools like **whoami**, **cat**, **curl** are already provide by OS.

### Prepare local environment

#### Steps

1. Copy _[sample.env](sample.env)_ to _.env_ and update _GCP_PROJECT_ID_ and _CLOUDFLARE_API_TOKEN_ variables.

    ```shell
    cp sample.env .env
    ```

2. Create and active the virtual environment.

    ```shell
    pipenv install
    pipenv shell
    ```

3. _(optional)_ Configure **gcloud** and log in, if you have not already done it.

    ```shell
    gcloud config configurations create ${GCP_PROJECT_ID}
    gcloud config set project ${GCP_PROJECT_ID}
    gcloud auth login
    gcloud auth application-default login
    ```

4. _(optional)_ Install **pre-commit** hooks, only for local development.

    ```shell
    pre-commit install
    ```

5. Change path to _configuration_ folder and install **Ansible** dependencies.

    ```shell
    ansible-galaxy role install -r requirements.yml --force
    ansible-galaxy collection install -r requirements.yml --force
    ```

## Hosting providers

### Hetzner

#### Steps

1. Update _HCLOUD_TOKEN_ in _.env_ file.

    ```shell
    # Reactivate the virtual environment to load new environment variables
    exit
    pipenv shell
    ```

2. Change path to root folder and set **Terraform** variables in _.env_ file.

    Check [infrastructure/modules/hetzner/README.md](infrastructure/modules/hetzner/README.md) for examples and available variables.

    ```shell
    # Use current OS user for SSH authentication
    echo -e "\nTF_VAR_ssh_user={\"user\":\"$(whoami)\",\"keys\":[\"$(cat ~/.ssh/id_rsa.pub)\"]}" >> .env

    # Allow SSH connections only from current public IP address
    echo -e "\nTF_VAR_ssh_allow_ipv4=[\"$(curl -s https://ifconfig.me)/32\"]" >> .env

    # Reactivate the virtual environment to load new environment variables
    exit
    pipenv shell
    ```

3. Change path to _infrastructure/environments/hetzner/server_ folder and create the infrastructure.

    ```shell
    terragrunt apply

    # Add DOKKU_HOST environment variable and reactivate pipenv shell to pick new environment variables
    echo -e "\nDOKKU_HOST=$(terragrunt output -json server_ip | jq -r)" >> ../../../../.env
    exit
    pipenv shell
    ```

4. Change path to _configuration_ folder and install **Dokku**. The **Ansible** playbook will also apply the [DevSec Hardening Framework Baselines](https://dev-sec.io/baselines/) for SSH and OS.

    ```shell
    # Check if Ansible can connect to server
    ansible-inventory --inventory hcloud.yml --graph
    ansible all --inventory hcloud.yml --module-name ping --limit label_project_dokku

    # Execute Ansible playbook for Hetzner cloud
    ansible-playbook playbooks/hetzner.yml --inventory hcloud.yml --limit label_project_dokku
    ```

## Smoke test

This test works on the assumption that you want to have an application accessible under a subdomain, for example `my-app.example.tld`.

Replace `my-app.example.tld` with the FQDN for your application.

### Steps

1. Change path to root folder and update _.env_ file.

    ```shell
    # Add application subdomains and reactivate pipenv shell to pick new environment variables
    echo -e "\nTF_VAR_dokku_apps_domains=[\"my-app.example.tld\"]" >> .env
    exit
    pipenv shell
    ```

2. Change path to _infrastructure/environments/hetzner/server_ folder and update **Cloudflare DNS**.

    ```shell
    terragrunt apply
    ```

3. Temporarily set [Cloudflare SSL/TLS](https://developers.cloudflare.com/ssl/origin-configuration/ssl-modes/flexible/) encryption mode to Flexible for `example.tld`.

4. Open [my-app.example.tld](https://my-app.example.tld) in browser.

## Next

Follow [Dokku docs](https://dokku.com/docs/deployment/application-deployment/) to deploy an application. Use [Cloudflare Origin CA certificate](https://developers.cloudflare.com/ssl/origin-configuration/origin-ca/) for SSL/TLS configuration.
