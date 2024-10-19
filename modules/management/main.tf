# Step 1: Define the Dataplex Lake
resource "google_dataplex_lake" "data_lake" {
  name        = var.dataplex_lake_name
  location    = var.location
  project     = var.proj_id
  description = "Dataplex lake for managing raw and clean data."

  labels = {
    environment = "production"
  }
}

# Step 2: Create the Raw Data Zone in Dataplex
resource "google_dataplex_zone" "raw_data_zone" {
  lake     = google_dataplex_lake.data_lake.name
  location = google_dataplex_lake.data_lake.location
  project  = google_dataplex_lake.data_lake.project
  name     = "raw-data-zone"
  type     = "RAW"  # Raw data zone type

  resource_spec {
    location_type = "MULTI_REGION"
  }

  discovery_spec {
    enabled = true
    include_patterns = ["*"]
  }

  labels = {
    zone = "raw-data"
  }
}

# Step 3: Create the Clean Data Zone in Dataplex
resource "google_dataplex_zone" "clean_data_zone" {
  lake     = google_dataplex_lake.data_lake.name
  location = google_dataplex_lake.data_lake.location
  project  = google_dataplex_lake.data_lake.project
  name     = "clean-data-zone"
  type     = "CURATED"  # Curated data zone type

  resource_spec {
    location_type = "MULTI_REGION"
  }

  discovery_spec {
    enabled = true
    include_patterns = ["*"]
  }

  labels = {
    zone = "clean-data"
  }
}

# Define the raw data asset
resource "google_dataplex_asset" "raw_data_asset" {
  project       = var.proj_id
  lake          = google_dataplex_lake.data_lake.name
  name          = "abcassetraw"
  location      = var.location
  dataplex_zone = google_dataplex_zone.raw_data_zone.name
  display_name  = "Raw Data Asset"
  description   = "Asset for raw data"

  # Resource specification block (for linking Cloud Storage)
  resource_spec {
    name = "projects/brcompute2/buckets/brcompute-rawbucket"
    # name          = var.raw_data_bucket_id
    type          = "STORAGE_BUCKET"
    # read_access_mode = "DIRECT"
  }

  # Discovery specification block (for metadata discovery)
  discovery_spec {
    enabled = true
  }
}

# Define the clean data asset
# resource "google_dataplex_asset" "clean_data_asset" {
#   project       = var.project_id
#   lake          = google_dataplex_lake.br_data_lake.name
#   dataplex_zone = google_dataplex_zone.clean_data_zone.name
#   asset_id      = "clean-data-asset"
#   display_name  = "Clean Data Asset"
#   description   = "Asset for clean data"

#   # Resource specification block (for linking Cloud Storage)
#   resource_spec {
#     name          = google_storage_bucket.cleandata.id
#     type          = "STORAGE_BUCKET"
#     read_access_mode = "DIRECT"
#   }

#   # Discovery specification block (for metadata discovery)
#   discovery_spec {
#     enabled = true
#   }
# }



# Step 4: Register Raw Data Storage Bucket as Asset
# resource "google_dataplex_asset" "raw_data_asset" {
#   lake     = google_dataplex_lake.data_lake.name
#   zone     = google_dataplex_zone.raw_data_zone.name
#   location = google_dataplex_lake.data_lake.location
#   project  = google_dataplex_lake.data_lake.project
#   name     = "raw-data-asset"
#   resource {
#     name = "projects/${var.proj_id}/buckets/${var.raw_data_bucket_name}"
#     type = "STORAGE_BUCKET"
#   }
#   discovery_spec {
#     enabled = true
#   }

#   labels = {
#     asset = "raw-data"
#   }
# }

# # Step 5: Register Clean Data Storage Bucket as Asset
# resource "google_dataplex_asset" "clean_data_asset" {
#   lake     = google_dataplex_lake.data_lake.name
#   zone     = google_dataplex_zone.clean_data_zone.name
#   location = google_dataplex_lake.data_lake.location
#   project  = google_dataplex_lake.data_lake.project
#   name     = "clean-data-asset"
#   resource {
#     name = "projects/${var.proj_id}/buckets/${var.clean_data_bucket_name}"
#     type = "STORAGE_BUCKET"
#   }
#   discovery_spec {
#     enabled = true
#   }

#   labels = {
#     asset = "clean-data"
#   }
# }
