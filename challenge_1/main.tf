# Setting up GCP as the provider for terraform so that it will downlaod the required plugins
provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}


#Saving the state to a GCS bucket

terraform {
  backend "gcs" {
    bucket      = "bucket-name"
    prefix      = "terraform/state1"
  }
}

resource "google_compute_instance" "web" {
  name         = var.server_name
  machine_type = var.machinetype

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = file("./server.sh")

  network_interface {
    network = "default"
    access_config {

    }

  }

}


# App engine creation . Assuming the code will be present in the GCS bucket

resource "google_app_engine_standard_app_version" "myapp_v1" {
  version_id = "v1"
  service    = "myapp"
  runtime    = "nodejs10"

  entrypoint {
    shell = "node ./app.js"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
    }
  }

  env_variables = {
    port = "8080"
  }

  automatic_scaling {
    max_concurrent_requests = 10
    min_idle_instances = 1
    max_idle_instances = 3
    min_pending_latency = "1s"
    max_pending_latency = "5s"
    standard_scheduler_settings {
      target_cpu_utilization = 0.5
      target_throughput_utilization = 0.75
      min_instances = 2
      max_instances = 10
    }
  }

  delete_service_on_destroy = true
}


resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name 
  location = "US"
}

resource "google_storage_bucket_object" "object" {
  name   = "hello-world.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./test-fixtures/appengine/hello-world.zip"
}


# creation of SQL Instance


resource "google_sql_database_instance" "sql" {
  name = var.sql_name
  database_version = "MYSQL_5_7"
  region = "us-central1"
} 




resource "google_sql_database" "db"{
    name = var.db_name 
    instance = "${google_sql_database_instance.sql.name}"
    charset = "utf8"
    collation = "utf8_general_ci"

}


resource "google_sql_user" "users" {
name = "root"
instance = "${google_sql_database_instance.sql.name}"
host = "%"
password = "XXXXXXXXX"
}