output "data_store_unstructured_references_id" {
  value = resource.google_discovery_engine_data_store.tf_ds_unstructured_references.data_store_id
}

output "data_store_structured_bq_id" {
  value = resource.google_discovery_engine_data_store.tf_ds_unstructured_references.data_store_id
}

output "test_engine_id" {
  value = resource.google_discovery_engine_search_engine.tf_searchengine.engine_id
}
