
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
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_locations_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_locations_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_bqtable_dfexports_micro" {
  project             = var.proj_id
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_exports_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_exports_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_bqtable_dfemigrants_micro" {
  project             = var.proj_id
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_emigrants_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_emigrants_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_bqtable_dfeducation_micro" {
  project             = var.proj_id
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_education_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_education_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_bqtable_dfimmigrants_micro" {
  project             = var.proj_id
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_immigrants_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_immigrants_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_bqtable_dfnationalAccounts_micro" {
  project             = var.proj_id
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_nationalAccounts_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_nationalAccounts_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_area_micro" {
  project             = var.proj_id
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_area_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_area_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_cempre_micro" {
  project             = var.proj_id
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_cempre_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_cempre_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_dcoast_micro" {
  project             = var.proj_id
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_dcoast_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_dcoast_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_distance_micro" {
  project             = var.proj_id
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_distance_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_distance_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_geoclass_micro" {
  project             = var.proj_id
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_geoclass_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_geoclass_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}

resource "google_bigquery_table" "tf_internalMigration_micro" {
  project             = var.proj_id
  dataset_id          = google_bigquery_dataset.tf_bqdataset_bronze.dataset_id
  table_id            = "df_internalMigration_micro"
  deletion_protection = false
  external_data_configuration {
    source_uris       = ["gs://personalvm-curated-bucket/micro/df_internalMigration_micro.csv"]
    source_format     = "CSV"
    autodetect        = true
  }
}


# DATAFORM ------------------------------------

#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dataform_repository
resource "google_dataform_repository" "tf_bqdataform_repository" {
  provider = google-beta
  name = "${var.proj_name}-dataform-repo"
  display_name = "${var.proj_name}-dataform-repo"
  git_remote_settings {
      url = "https://github.com/personalVM/data_warehouse.git"
      default_branch = "main"
      authentication_token_secret_version = "projects/292524820499/secrets/dataform-github-personal-access-token/versions/latest" #TODO
  }
  workspace_compilation_overrides {
    default_database = var.proj_id
    schema_suffix = ""
    table_prefix = ""
  }
  # depends_on = [google_bigquery_dataset.tf_bqdataset_bronze]
}

resource "google_dataform_repository_release_config" "tf_bqdataform_release" {
  provider = google-beta
  project    = google_dataform_repository.tf_bqdataform_repository.project
  region     = google_dataform_repository.tf_bqdataform_repository.region
  repository = google_dataform_repository.tf_bqdataform_repository.name
  name          = "my_release"
  git_commitish = "main"
  cron_schedule = "0 7 * * *"
  time_zone     = "America/New_York"
  code_compilation_config {
    default_database = "bronze"
    default_schema   = "bronze"
    default_location = var.location
    assertion_schema = "example-assertion-dataset"
    database_suffix  = ""
    schema_suffix    = ""
    table_prefix     = ""
    vars = {
      var1 = "value"
    }
  }
}

resource "google_dataform_repository_workflow_config" "tf_bqdataform_workflow" {
  provider       = google-beta
  project        = google_dataform_repository.tf_bqdataform_repository.project
  region         = google_dataform_repository.tf_bqdataform_repository.region
  repository     = google_dataform_repository.tf_bqdataform_repository.name
  name           = "my_workflow"
  release_config = google_dataform_repository_release_config.tf_bqdataform_release.id
  invocation_config {
    included_targets {
      database = "silver"
      schema   = "schema1"
      name     = "target1"
    }
    included_targets {
      database = "gold"
      schema   = "schema2"
      name     = "target2"
    }
    transitive_dependencies_included         = true
    transitive_dependents_included           = true
    fully_refresh_incremental_tables_enabled = false
    # service_account                          = google_service_account.dataform_sa.email
  }
  cron_schedule   = "0 7 * * *"
  time_zone       = "America/New_York"
}


