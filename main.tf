module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "strong-host-322803"
  name                       = "gke-test-1"
  region                     = "us-central1"
  zones                      = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network                    = "default"
  subnetwork                 = "default"
  ip_range_pods              = ""
  ip_range_services          = ""
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = false

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-2"
      min_count          = 1
      max_count          = 2  # quota errors if the number is too high
      disk_size_gb       = 10
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = "true"
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

#  node_pools_taints = {
#    all = []
#
#    default-node-pool = [
#      {
#        key    = "default-node-pool"
#        value  = "true"
#        effect = "PREFER_NO_SCHEDULE"
#      },
#    ]
#  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}


locals {
  rds_name = "odoo-${random_string.suffix.result}"
}
resource "random_string" "suffix" {
  length  = 4
  special = false
  lower = true
  upper = false
  number = false
}
# Create Database
resource "google_sql_database_instance" "gcp_database" {
    name = local.rds_name
    region = "${var.db_region}"
    database_version = "${var.database_version}"
    deletion_protection = false

    settings {
        tier = "${var.tier}"
        disk_size = "${var.disk_size}"
       # replication_type = "${var.replication_type}"
        activation_policy = "${var.activation_policy}"
       
    }
}

# Create User

resource "google_sql_user" "admin" {
    count = 1 
    name = "${var.user_name}"
    password = "${var.user_password}"
    instance = "${google_sql_database_instance.gcp_database.name}"
}
