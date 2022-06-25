resource "random_id" "db_name_suffix" {
  byte_length = 4
}
resource "google_compute_global_address" "private_ip_address" {
  project   = var.project
  name      = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network       = "${google_compute_network.vpc_net.self_link}"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network       = "${google_compute_network.vpc_net.self_link}"
  service       = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}

resource "google_sql_database_instance" "instance" {
  project    = var.project
  name = "private-instance-5"
  region = "us-west1"
  database_version = "MYSQL_5_7"

deletion_protection = "false"

  depends_on = [
    "google_service_networking_connection.private_vpc_connection"
  ]

  settings {
    tier = "db-f1-micro"
	availability_type = "REGIONAL"
	disk_size         = "100"
    ip_configuration {
      ipv4_enabled = "false"
      private_network = "${google_compute_network.vpc_net.self_link}"
    }
    backup_configuration {
      binary_log_enabled = true
      enabled            = true
      location           = "us"
      start_time         = "18:00"
    }
  }
}
output "Db-IP" {
  value = google_sql_database_instance.instance.first_ip_address
  depends_on=[google_sql_database_instance.instance]
}
resource "google_sql_user" "users" {
  project    = var.project
  name     = "bibek"
  instance = google_sql_database_instance.instance.name
  password = "redhat"
  host = "%"
  depends_on=[google_sql_database_instance.instance]
}
resource "google_sql_database" "database" {
  project    = var.project
  name     = "wordpress"
  instance = google_sql_database_instance.instance.name
}
resource "google_sql_database_instance" "read_replica" {
  project    = var.project
  name                 = "replica-${random_id.db_name_suffix.hex}"
  master_instance_name = "${var.project}:${google_sql_database_instance.instance.name}"
  region               = "us-west1"
  database_version     = "MYSQL_5_7"

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"
    disk_size         = "100"
    backup_configuration {
      enabled = false
    }
    ip_configuration {
      ipv4_enabled    = false
      private_network = "${google_compute_network.vpc_net.self_link}"
    }
    location_preference {
      zone = "us-west1-a"
    }
  }
}