terraform {
  cloud {
    organization = "example-org-e436c4"

    workspaces {
      name = "poc-iac-iaas-etl"
    }
  }
}