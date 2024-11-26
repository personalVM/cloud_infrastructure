

# resource "google_bigquery_dataset" "tf_curatedbucket" {
#   project = var.proj_id
#   dataset_id = "curatedbucket"
#   location   = var.location
# }

resource "google_bigquery_dataset" "tf_bqdataset_bronze" {
  project = var.proj_id
  dataset_id = "bronze"
  location   = var.location
}

resource "google_bigquery_dataset" "tf_bqdataset_silver" {
  project = var.proj_id
  dataset_id = "silver"
  location   = var.location
}

resource "google_bigquery_dataset" "tf_bqdataset_gold" {
  project = var.proj_id
  dataset_id = "gold"
  location   = var.location
}

resource "google_bigquery_table" "tf_bqtable_dflocations_micro" {
  project             = var.proj_id
  dataset_id          = "bronze" # google_bigquery_dataset.tf_.dataset_id
  table_id            = "df_locations_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curatedbucket/micro/df_locations_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_bqtable_dfexports_micro" {
  project             = var.proj_id
  dataset_id          = "bronze"
  table_id            = "df_exports_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curatedbucket/micro/df_exports_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_bqtable_dfemigrants_micro" {
  project             = var.proj_id
  dataset_id          = "bronze"
  table_id            = "df_emigrants_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curatedbucket/micro/df_emigrants_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_bqtable_dfeducation_micro" {
  project             = var.proj_id
  dataset_id          = "bronze"
  table_id            = "df_education_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curatedbucket/micro/df_education_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_bqtable_dfimmigrants_micro" {
  project             = var.proj_id
  dataset_id          = "bronze"
  table_id            = "df_immigrants_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curatedbucket/micro/df_immigrants_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_bqtable_dfnationalAccounts_micro" {
  project             = var.proj_id
  dataset_id          = "bronze"
  table_id            = "df_nationalAccounts_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curatedbucket/micro/df_nationalAccounts_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}



