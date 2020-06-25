provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
}

data "vra_zone" "this" {
  name = var.zone_name
}

resource "vra_project" "this" {
  name = var.project_name

  zone_assignments {
    zone_id          = data.vra_zone.this.id
    priority         = 1
    max_instances    = 2
    cpu_limit        = 1024
    memory_limit_mb  = 8192
    storage_limit_gb = 65536
  }

  shared_resources = false

  administrators = ["syujiang@vmware.com"]
}

resource "vra_blueprint" "this" {
  name        = var.blueprint_name
  description = "Created by vRA terraform provider"
  project_id = vra_project.this.id
  content = <<-EOT
    formatVersion: 1
    inputs: {}
    resources:
      Cloud_Network_1:
        type: Cloud.Network
        properties:
          networkType: existing
      Cloud_Machine_2:
        type: Cloud.Machine
        properties:
          image: ubuntu
          flavor: small
          networks:
            - network: '$${resource.Cloud_Network_1.id}'
      Cloud_Machine_1:
        type: Cloud.Machine
        properties:
          image: ubuntu
          flavor: small
          networks:
           - network: '$${resource.Cloud_Network_1.id}'
  EOT
}





