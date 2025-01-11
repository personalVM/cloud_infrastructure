
resource "google_discovery_engine_data_store" "tf_ds_personal" {
    project = var.proj_id
    location = "global"
    data_store_id = "${var.proj_name}-ds-personal5"
    display_name = "Personal Data Store"
    industry_vertical = "GENERIC"
    content_config = "CONTENT_REQUIRED"
    solution_types = ["SOLUTION_TYPE_SEARCH"] # Vertex AI Search
    create_advanced_site_search = false
    lifecycle {
        prevent_destroy = true
    }
}

resource "google_discovery_engine_data_store" "tf_ds_unstructured_references" {
    project = var.proj_id
    location = "global"
    data_store_id = "${var.proj_name}-ds-references5"
    display_name = "References Data Store"
    industry_vertical = "GENERIC"
    content_config = "CONTENT_REQUIRED"
    solution_types = ["SOLUTION_TYPE_SEARCH"] # Vertex AI Search
    create_advanced_site_search = false
    lifecycle {
        prevent_destroy = true
    }
}

resource "google_discovery_engine_data_store" "tf_ds_structured_bq" {
    project = var.proj_id
    location = "global"
    data_store_id = "${var.proj_name}-ds-bq5"
    display_name = "BQ Data Store"
    industry_vertical = "GENERIC"
    content_config = "CONTENT_REQUIRED"
    solution_types = ["SOLUTION_TYPE_SEARCH"] # Vertex AI Search
    create_advanced_site_search = false
    lifecycle {
        prevent_destroy = true
    }
}

resource "google_discovery_engine_search_engine" "tf_searchengine" {
    depends_on = [google_discovery_engine_data_store.tf_ds_personal, google_discovery_engine_data_store.tf_ds_unstructured_references, google_discovery_engine_data_store.tf_ds_structured_bq]
    project = var.proj_id
    engine_id = "${var.proj_name}-personal-se"
    display_name = "Personal Seearch Engine"
    collection_id = "default_collection"
    location = google_discovery_engine_data_store.tf_ds_unstructured_references.location
    industry_vertical = "GENERIC"
    data_store_ids = [google_discovery_engine_data_store.tf_ds_personal.data_store_id, google_discovery_engine_data_store.tf_ds_unstructured_references.data_store_id, google_discovery_engine_data_store.tf_ds_structured_bq.data_store_id]
    common_config {
        company_name = "Guigo"
    }
    search_engine_config {
        search_add_ons = ["SEARCH_ADD_ON_LLM"]
    }
}

# GWR Discovery Search: ----------------------------------------------------------

resource "google_discovery_engine_data_store" "tf_gwr_references_datastore" {
    project = var.proj_id
    location = "global"
    data_store_id = "${var.proj_name}-ds-gwr-main"
    display_name = "GWR References DataStore"
    industry_vertical = "GENERIC"
    content_config = "CONTENT_REQUIRED"
    solution_types = ["SOLUTION_TYPE_SEARCH"] # Vertex AI Search
    create_advanced_site_search = false
    lifecycle {
        prevent_destroy = false
    }
}

resource "google_discovery_engine_data_store" "tf_gwr_allreferences_datastore" {
    project = var.proj_id
    location = "global"
    data_store_id = "${var.proj_name}-ds-gwr-all"
    display_name = "GWR all References DataStore"
    industry_vertical = "GENERIC"
    content_config = "CONTENT_REQUIRED"
    solution_types = ["SOLUTION_TYPE_SEARCH"] # Vertex AI Search
    create_advanced_site_search = false
    lifecycle {
        prevent_destroy = false
    }
}

resource "google_discovery_engine_search_engine" "tf_gwr_searchengine" {
    depends_on = [google_discovery_engine_data_store.tf_gwr_references_datastore]
    project = var.proj_id
    engine_id = "${var.proj_name}-gwr-se"
    display_name = "GWR References Seearch Engine"
    collection_id = "default_collection"
    location = google_discovery_engine_data_store.tf_gwr_references_datastore.location
    industry_vertical = "GENERIC"
    data_store_ids = [google_discovery_engine_data_store.tf_gwr_references_datastore.data_store_id, google_discovery_engine_data_store.tf_gwr_allreferences_datastore.data_store_id]
    common_config {
        company_name = "Guigo"
    }
    search_engine_config {
        search_add_ons = ["SEARCH_ADD_ON_LLM"]
    }
}













# Output resource Id's
# output "test_data_store_id" {
#   value =resource.google_discovery_engine_data_store.test-ds.data_store_id
# }
# output "test_engine_id" {
#   value = resource.google_discovery_engine_search_engine.test-engine.engine_id
# }




# # provider "google-beta" {
# #   project     = var.proj_id
# #   region      = local.location
# # }


# # abc
# resource "google_storage_bucket" "tf_dialogflowcx_bucket" {
#   name                        = "dialogflowcx-bucket-guigo"
#   location                    = "US"
#   uniform_bucket_level_access = true
# }

# #abc
# resource "google_discovery_engine_data_store" "tf_datastore" {
#   project                     = local.proj_id
#   location                    = "global"
#   data_store_id               = "data-store123-id"
#   display_name                = "data-store123-name"
#   industry_vertical           = "GENERIC"
#   content_config              = "NO_CONTENT"
#   solution_types              = ["SOLUTION_TYPE_SEARCH"] #   solution_types - (Optional) The solutions that the data store enrolls. Each value may be one of: SOLUTION_TYPE_RECOMMENDATION, SOLUTION_TYPE_SEARCH, SOLUTION_TYPE_CHAT, SOLUTION_TYPE_GENERATIVE_CHAT
#   create_advanced_site_search = false
#   document_processing_config {
#     default_parsing_config  {
#       digital_parsing_config {}
#     }
#     parsing_config_overrides {
#       file_type = "pdf"
#       ocr_parsing_config {
#         use_native_text = true
#       }
#     }
#   }        
# }

# # abc
# resource "google_dialogflow_cx_agent" "tf_full_agent" {
#   display_name = "dialogflowcx-agent-guigo123"
#   location = "us-central1"
#   default_language_code = "en"
#   supported_language_codes = ["pt","de","es"]
#   time_zone = "America/New_York"
#   description = "Example description."
#   avatar_uri = "https://cloud.google.com/_static/images/cloud/icons/favicons/onecloud/super_cloud.png"
#   #   enable_stackdriver_logging = true
#   enable_spell_correction    = true
#   speech_to_text_settings {
#     enable_speech_adaptation = true
#   }
#   advanced_settings {
#     audio_export_gcs_destination {
#       uri = "${google_storage_bucket.tf_dialogflowcx_bucket.url}/prefix-"
#     }
#     speech_settings {
#       endpointer_sensitivity        = 30
#       no_speech_timeout             = "3.600s"
#       use_timeout_based_endpointing = true
#       models = {
#         name : "wrench"
#         mass : "1.3kg"
#         count : "3"
#       }
#     }
#     dtmf_settings {
#       enabled      = true
#       max_digits   = 1
#       finish_digit = "#"
#     }
#     logging_settings {
#       enable_stackdriver_logging     = true
#       enable_interaction_logging     = true
#       enable_consent_based_redaction = true
#     }
#   }
#     #   git_integration_settings {
#     #     github_settings {
#     #       display_name = "Github Repo"
#     #       repository_uri = "https://api.github.com/repos/githubtraining/hellogitworld"
#     #       tracking_branch = "main"
#     #       access_token = "secret-token"
#     #       branches = ["main"]
#     #     }
#     #   }
#   text_to_speech_settings {
#     synthesize_speech_configs = jsonencode({
#       en = {
#         voice = {
#           name = "en-US-Neural2-A"
#         }
#       }
#       fr = {
#         voice = {
#           name = "fr-CA-Neural2-A",
#         }
#       }
#     })
#   }
# }

# # abc
# resource "google_dialogflow_cx_entity_type" "tf_basic_entity_type" {
#   parent       = google_dialogflow_cx_agent.tf_full_agent.id
#   display_name = "MyEntity"
#   kind         = "KIND_MAP"
#   entities {
#     value = "value1"
#     synonyms = ["synonym1","synonym2"]
#   }
#   entities {
#     value = "value2"
#     synonyms = ["synonym3","synonym4"]
#   }
#   enable_fuzzy_extraction = false
# } 

# # abc
# resource "google_dialogflow_cx_version" "version_1" {
#   parent       = google_dialogflow_cx_agent.tf_full_agent.start_flow
#   display_name = "1.0.0"
#   description  = "version 1.0.0"
# }

# # abc
# resource "google_dialogflow_cx_environment" "development" {
#   parent       = google_dialogflow_cx_agent.tf_full_agent.id
#   display_name = "Development"
#   description  = "Development Environment..122131234123123123123123"
#   version_configs {
#     version = google_dialogflow_cx_version.version_1.id
#   }
# }

# # abc
# resource "google_dialogflow_cx_flow" "basic_flow" {
#   parent       = google_dialogflow_cx_agent.tf_full_agent.id
#   display_name = "MyFlow"
#   description  = "Test Flow"
#   nlu_settings {
#     classification_threshold = 0.3
#     model_type               = "MODEL_TYPE_STANDARD"
#   }

#   event_handlers {
#     event = "custom-event1"
#     trigger_fulfillment {
#       return_partial_responses = false
#       messages {
#         text {
#           text = ["Bitte?"]
#         }
#       }
#     }
#   }

#   event_handlers {
#     event = "custom-event2"
#     trigger_fulfillment {
#       return_partial_responses = false
#       messages {
#         text {
#           text = ["I didn't get that. Can you say it again?"]
#         }
#       }
#     }
#   }

#   event_handlers {
#     event = "sys.no-match-default"
#     trigger_fulfillment {
#       return_partial_responses = false
#       messages {
#         text {
#           text = ["Sorry, could you say that again?"]
#         }
#       }
#     }
#   }

#   event_handlers {
#     event = "sys.no-input-default"
#     trigger_fulfillment {
#       return_partial_responses = false
#       messages {
#         text {
#           text = ["One more time?"]
#         }
#       }
#     }
#   }
# }

# # Advanced Flow
# resource "google_dialogflow_cx_flow" "advanced_flow" {
#   parent       = google_dialogflow_cx_agent.tf_full_agent.id
#   display_name = "MyFlowAdvanced"
#   description  = "Test Flow advanced"

#   nlu_settings {
#     classification_threshold = 0.3
#     model_type               = "MODEL_TYPE_STANDARD"
#   }

#   event_handlers {
#     event = "custom-event"
#     trigger_fulfillment {
#       return_partial_responses = false
#       messages {
#         text {
#           text = ["I didn't get that. Can you say it again?"]
#         }
#       }
#     }
#   }

#   event_handlers {
#     event = "sys.no-match-default"
#     trigger_fulfillment {
#       return_partial_responses = false
#       messages {
#         text {
#           text = ["Sorry, could you say that again?"]
#         }
#       }
#     }
#   }

#   event_handlers {
#     event = "sys.no-input-default"
#     trigger_fulfillment {
#       return_partial_responses = false
#       messages {
#         text {
#           text = ["One more time?"]
#         }
#       }
#     }
#   }

#   event_handlers {
#     event = "another-event"
#     trigger_fulfillment {
#       return_partial_responses = true
#       messages {
#         channel = "some-channel"
#         text {
#           text = ["Some text"]
#         }
#       }
#       messages {
#         payload = <<EOF
#           {"some-key": "some-value", "other-key": ["other-value"]}
#         EOF
#       }
#       messages {
#         conversation_success {
#           metadata = <<EOF
#             {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#           EOF
#         }
#       }
#       messages {
#         output_audio_text {
#           text = "some output text"
#         }
#       }
#       messages {
#         output_audio_text {
#           ssml = <<EOF
#             <speak>Some example <say-as interpret-as="characters">SSML XML</say-as></speak>
#           EOF
#         }
#       }
#       messages {
#         live_agent_handoff {
#           metadata = <<EOF
#             {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#           EOF
#         }
#       }
#       messages {
#         play_audio {
#           audio_uri = "http://example.com/some-audio-file.mp3"
#         }
#       }
#       messages {
#         telephony_transfer_call {
#           phone_number = "1-234-667-8901"
#         }
#       }

#       set_parameter_actions {
#         parameter = "some-param"
#         value     = "123.46"
#       }
#       set_parameter_actions {
#         parameter = "another-param"
#         value     = jsonencode("abc")
#       }
#       set_parameter_actions {
#         parameter = "other-param"
#         value     = jsonencode(["foo"])
#       }

#       conditional_cases {
#         cases = jsonencode([
#           {
#             condition = "$sys.func.RAND() < 0.6",
#             caseContent = [
#               {
#                 message = { text = { text = ["First case"] } }
#               },
#               {
#                 additionalCases = {
#                   cases = [
#                     {
#                       condition = "$sys.func.RAND() < 0.2"
#                       caseContent = [
#                         {
#                           message = { text = { text = ["Nested case"] } }
#                         }
#                       ]
#                     }
#                   ]
#                 }
#               }
#             ]
#           },
#           {
#             caseContent = [
#               {
#                 message = { text = { text = ["Final case"] } }
#               }
#             ]
#           },
#         ])
#       }
#     }
#   }

#   transition_routes {
#     condition = "true"
#     trigger_fulfillment {
#       return_partial_responses = true
#       messages {
#         channel = "some-channel"
#         text {
#           text = ["Some text"]
#         }
#       }
#       messages {
#         payload = <<EOF
#           {"some-key": "some-value", "other-key": ["other-value"]}
#         EOF
#       }
#       messages {
#         conversation_success {
#           metadata = <<EOF
#             {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#           EOF
#         }
#       }
#       messages {
#         output_audio_text {
#           text = "some output text"
#         }
#       }
#       messages {
#         output_audio_text {
#           ssml = <<EOF
#             <speak>Some example <say-as interpret-as="characters">SSML XML</say-as></speak>
#           EOF
#         }
#       }
#       messages {
#         live_agent_handoff {
#           metadata = <<EOF
#             {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#           EOF
#         }
#       }
#       messages {
#         play_audio {
#           audio_uri = "http://example.com/some-audio-file.mp3"
#         }
#       }
#       messages {
#         telephony_transfer_call {
#           phone_number = "1-234-667-8901"
#         }
#       }

#       set_parameter_actions {
#         parameter = "some-param"
#         value     = "123.46"
#       }
#       set_parameter_actions {
#         parameter = "another-param"
#         value     = jsonencode("abc")
#       }
#       set_parameter_actions {
#         parameter = "other-param"
#         value     = jsonencode(["foo"])
#       }

#       conditional_cases {
#         cases = jsonencode([
#           {
#             condition = "$sys.func.RAND() < 0.6",
#             caseContent = [
#               {
#                 message = { text = { text = ["First case"] } }
#               },
#               {
#                 additionalCases = {
#                   cases = [
#                     {
#                       condition = "$sys.func.RAND() < 0.2"
#                       caseContent = [
#                         {
#                           message = { text = { text = ["Nested case"] } }
#                         }
#                       ]
#                     }
#                   ]
#                 }
#               }
#             ]
#           },
#           {
#             caseContent = [
#               {
#                 message = { text = { text = ["Final case"] } }
#               }
#             ]
#           },
#         ])
#       }
#     }
#     target_flow = google_dialogflow_cx_agent.tf_full_agent.start_flow
#   }

#   advanced_settings {
#     audio_export_gcs_destination {
#       uri = "${google_storage_bucket.tf_dialogflowcx_bucket.url}/prefix-"
#     }
#     speech_settings {
#       endpointer_sensitivity        = 30
#       no_speech_timeout             = "3.600s"
#       use_timeout_based_endpointing = true
#       models = {
#         name : "wrench"
#         mass : "1.3kg"
#         count : "3"
#       }
#     }
#     dtmf_settings {
#       enabled      = true
#       max_digits   = 1
#       finish_digit = "#"
#     }
#     logging_settings {
#       enable_stackdriver_logging     = true
#       enable_interaction_logging     = true
#       enable_consent_based_redaction = true
#     }
#   }
# } 

# # Intent ----
# ## An intent represents a user's intent to interact with a conversational agent.
# resource "google_dialogflow_cx_intent" "basic_intent" {
#   parent       = google_dialogflow_cx_agent.tf_full_agent.id
#   display_name = "Example"
#   priority     = 1
#   description  = "Intent example"
#   training_phrases {
#      parts {
#          text = "training"
#      }

#      parts {
#          text = "phrase"
#      }

#      parts {
#          text = "example"
#      }

#      repeat_count = 1
#   }

#   parameters {
#     id          = "param1"
#     entity_type = "projects/-/locations/-/agents/-/entityTypes/sys.date"
#   }

#   labels  = {
#       label1 = "value1",
#       label2 = "value2"
#    } 
# } 

# # abc
# resource "google_dialogflow_cx_page" "basic_page" {
#   parent       = google_dialogflow_cx_agent.tf_full_agent.start_flow
#   display_name = "MyPage0"
#   entry_fulfillment {
#     messages {
#       channel = "some-channel"
#       text {
#         text = ["Welcome to page"]
#       }
#     }
#     messages {
#       payload = <<EOF
#         {"some-key": "some-value", "other-key": ["other-value"]}
#       EOF
#     }
#     messages {
#       conversation_success {
#         metadata = <<EOF
#           {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#         EOF
#       }
#     }
#     messages {
#       output_audio_text {
#         text = "some output text"
#       }
#     }
#     messages {
#       output_audio_text {
#         ssml = <<EOF
#           <speak>Some example <say-as interpret-as="characters">SSML XML</say-as></speak>
#         EOF
#       }
#     }
#     messages {
#       live_agent_handoff {
#         metadata = <<EOF
#           {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#         EOF
#       }
#     }
#     messages {
#       play_audio {
#         audio_uri = "http://example.com/some-audio-file.mp3"
#       }
#     }
#     messages {
#       telephony_transfer_call {
#         phone_number = "1-234-667-8901"
#       }
#     }

#     set_parameter_actions {
#       parameter = "some-param"
#       value     = "123.46"
#     }
#     set_parameter_actions {
#       parameter = "another-param"
#       value     = jsonencode("abc")
#     }
#     set_parameter_actions {
#       parameter = "other-param"
#       value     = jsonencode(["foo"])
#     }

#     conditional_cases {
#       cases = jsonencode([
#         {
#           condition = "$sys.func.RAND() < 0.6",
#           caseContent = [
#             {
#               message = { text = { text = ["First case"] } }
#             },
#             {
#               additionalCases = {
#                 cases = [
#                   {
#                     condition = "$sys.func.RAND() < 0.2"
#                     caseContent = [
#                       {
#                         message = { text = { text = ["Nested case"] } }
#                       }
#                     ]
#                   }
#                 ]
#               }
#             }
#           ]
#         },
#         {
#           caseContent = [
#             {
#               message = { text = { text = ["Final case"] } }
#             }
#           ]
#         },
#       ])
#     }
#   }

#   event_handlers {
#     event = "some-event"
#     trigger_fulfillment {
#       return_partial_responses = true
#       messages {
#         channel = "some-channel"
#         text {
#           text = ["Some text"]
#         }
#       }
#       messages {
#         payload = <<EOF
#           {"some-key": "some-value", "other-key": ["other-value"]}
#         EOF
#       }
#       messages {
#         conversation_success {
#           metadata = <<EOF
#             {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#           EOF
#         }
#       }
#       messages {
#         output_audio_text {
#           text = "some output text"
#         }
#       }
#       messages {
#         output_audio_text {
#           ssml = <<EOF
#             <speak>Some example <say-as interpret-as="characters">SSML XML</say-as></speak>
#           EOF
#         }
#       }
#       messages {
#         live_agent_handoff {
#           metadata = <<EOF
#             {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#           EOF
#         }
#       }
#       messages {
#         play_audio {
#           audio_uri = "http://example.com/some-audio-file.mp3"
#         }
#       }
#       messages {
#         telephony_transfer_call {
#           phone_number = "1-234-667-8901"
#         }
#       }

#       set_parameter_actions {
#         parameter = "some-param"
#         value     = "123.46"
#       }
#       set_parameter_actions {
#         parameter = "another-param"
#         value     = jsonencode("abc")
#       }
#       set_parameter_actions {
#         parameter = "other-param"
#         value     = jsonencode(["foo"])
#       }

#       conditional_cases {
#         cases = jsonencode([
#           {
#             condition = "$sys.func.RAND() < 0.6",
#             caseContent = [
#               {
#                 message = { text = { text = ["First case"] } }
#               },
#               {
#                 additionalCases = {
#                   cases = [
#                     {
#                       condition = "$sys.func.RAND() < 0.2"
#                       caseContent = [
#                         {
#                           message = { text = { text = ["Nested case"] } }
#                         }
#                       ]
#                     }
#                   ]
#                 }
#               }
#             ]
#           },
#           {
#             caseContent = [
#               {
#                 message = { text = { text = ["Final case"] } }
#               }
#             ]
#           },
#         ])
#       }
#     }
#   }

#   form {
#     parameters {
#       display_name = "param1"
#       entity_type  = "projects/-/locations/-/agents/-/entityTypes/sys.date"
#       default_value = jsonencode("2000-01-01")
#       fill_behavior {
#         initial_prompt_fulfillment {
#           messages {
#             channel = "some-channel"
#             text {
#               text = ["Please provide param1"]
#             }
#           }
#           messages {
#             payload = <<EOF
#               {"some-key": "some-value", "other-key": ["other-value"]}
#             EOF
#           }
#           messages {
#             conversation_success {
#               metadata = <<EOF
#                 {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#               EOF
#             }
#           }
#           messages {
#             output_audio_text {
#               text = "some output text"
#             }
#           }
#           messages {
#             output_audio_text {
#               ssml = <<EOF
#                 <speak>Some example <say-as interpret-as="characters">SSML XML</say-as></speak>
#               EOF
#             }
#           }
#           messages {
#             live_agent_handoff {
#               metadata = <<EOF
#                 {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#               EOF
#             }
#           }
#           messages {
#             play_audio {
#               audio_uri = "http://example.com/some-audio-file.mp3"
#             }
#           }
#           messages {
#             telephony_transfer_call {
#               phone_number = "1-234-667-8901"
#             }
#           }

#           set_parameter_actions {
#             parameter = "some-param"
#             value     = "123.46"
#           }
#           set_parameter_actions {
#             parameter = "another-param"
#             value     = jsonencode("abc")
#           }
#           set_parameter_actions {
#             parameter = "other-param"
#             value     = jsonencode(["foo"])
#           }

#           conditional_cases {
#             cases = jsonencode([
#               {
#                 condition = "$sys.func.RAND() < 0.6",
#                 caseContent = [
#                   {
#                     message = { text = { text = ["First case"] } }
#                   },
#                   {
#                     additionalCases = {
#                       cases = [
#                         {
#                           condition = "$sys.func.RAND() < 0.2"
#                           caseContent = [
#                             {
#                               message = { text = { text = ["Nested case"] } }
#                             }
#                           ]
#                         }
#                       ]
#                     }
#                   }
#                 ]
#               },
#               {
#                 caseContent = [
#                   {
#                     message = { text = { text = ["Final case"] } }
#                   }
#                 ]
#               },
#             ])
#           }
#         }
#         reprompt_event_handlers {
#           event = "sys.no-match-1"
#           trigger_fulfillment {
#             return_partial_responses = true
#             webhook = google_dialogflow_cx_webhook.my_webhook.id
#             tag = "some-tag"

#             messages {
#               channel = "some-channel"
#               text {
#                 text = ["Please provide param1"]
#               }
#             }
#             messages {
#               payload = <<EOF
#                 {"some-key": "some-value", "other-key": ["other-value"]}
#               EOF
#             }
#             messages {
#               conversation_success {
#                 metadata = <<EOF
#                   {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#                 EOF
#               }
#             }
#             messages {
#               output_audio_text {
#                 text = "some output text"
#               }
#             }
#             messages {
#               output_audio_text {
#                 ssml = <<EOF
#                   <speak>Some example <say-as interpret-as="characters">SSML XML</say-as></speak>
#                 EOF
#               }
#             }
#             messages {
#               live_agent_handoff {
#                 metadata = <<EOF
#                   {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#                 EOF
#               }
#             }
#             messages {
#               play_audio {
#                 audio_uri = "http://example.com/some-audio-file.mp3"
#               }
#             }
#             messages {
#               telephony_transfer_call {
#                 phone_number = "1-234-567-8901"
#               }
#             }

#             set_parameter_actions {
#               parameter = "some-param"
#               value     = "123.45"
#             }
#             set_parameter_actions {
#               parameter = "another-param"
#               value     = jsonencode("abc")
#             }
#             set_parameter_actions {
#               parameter = "other-param"
#               value     = jsonencode(["foo"])
#             }

#             conditional_cases {
#               cases = jsonencode([
#                 {
#                   condition = "$sys.func.RAND() < 0.5",
#                   caseContent = [
#                     {
#                       message = { text = { text = ["First case"] } }
#                     },
#                     {
#                       additionalCases = {
#                         cases = [
#                           {
#                             condition = "$sys.func.RAND() < 0.2"
#                             caseContent = [
#                               {
#                                 message = { text = { text = ["Nested case"] } }
#                               }
#                             ]
#                           }
#                         ]
#                       }
#                     }
#                   ]
#                 },
#                 {
#                   caseContent = [
#                     {
#                       message = { text = { text = ["Final case"] } }
#                     }
#                   ]
#                 },
#               ])
#             }
#           }
#         }
#         reprompt_event_handlers {
#           event = "sys.no-match-2"
#           target_flow = google_dialogflow_cx_agent.tf_full_agent.start_flow
#         }
#         reprompt_event_handlers {
#           event = "sys.no-match-3"
#           target_page = google_dialogflow_cx_page.my_page2.id
#         }
#       }
#       required = "true"
#       redact   = "true"
#       advanced_settings {
#         dtmf_settings {
#           enabled      = true
#           max_digits   = 1
#           finish_digit = "#"
#         }
#       }
#     }
#   }

#   transition_routes {
#     condition = "$page.params.status = 'FINAL'"
#     trigger_fulfillment {
#       messages {
#         channel = "some-channel"
#         text {
#           text = ["information completed, navigating to page 2"]
#         }
#       }
#       messages {
#         payload = <<EOF
#           {"some-key": "some-value", "other-key": ["other-value"]}
#         EOF
#       }
#       messages {
#         conversation_success {
#           metadata = <<EOF
#             {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#           EOF
#         }
#       }
#       messages {
#         output_audio_text {
#           text = "some output text"
#         }
#       }
#       messages {
#         output_audio_text {
#           ssml = <<EOF
#             <speak>Some example <say-as interpret-as="characters">SSML XML</say-as></speak>
#           EOF
#         }
#       }
#       messages {
#         live_agent_handoff {
#           metadata = <<EOF
#             {"some-metadata-key": "some-value", "other-metadata-key": 1234}
#           EOF
#         }
#       }
#       messages {
#         play_audio {
#           audio_uri = "http://example.com/some-audio-file.mp3"
#         }
#       }
#       messages {
#         telephony_transfer_call {
#           phone_number = "1-234-567-8901"
#         }
#       }

#       set_parameter_actions {
#         parameter = "some-param"
#         value     = "123.45"
#       }
#       set_parameter_actions {
#         parameter = "another-param"
#         value     = jsonencode("abc")
#       }
#       set_parameter_actions {
#         parameter = "other-param"
#         value     = jsonencode(["foo"])
#       }

#       conditional_cases {
#         cases = jsonencode([
#           {
#             condition = "$sys.func.RAND() < 0.5",
#             caseContent = [
#               {
#                 message = { text = { text = ["First case"] } }
#               },
#               {
#                 additionalCases = {
#                   cases = [
#                     {
#                       condition = "$sys.func.RAND() < 0.2"
#                       caseContent = [
#                         {
#                           message = { text = { text = ["Nested case"] } }
#                         }
#                       ]
#                     }
#                   ]
#                 }
#               }
#             ]
#           },
#           {
#             caseContent = [
#               {
#                 message = { text = { text = ["Final case"] } }
#               }
#             ]
#           },
#         ])
#       }
#     }
#     target_page = google_dialogflow_cx_page.my_page2.id
#   }

#   advanced_settings {
#     dtmf_settings {
#       enabled      = true
#       max_digits   = 1
#       finish_digit = "#"
#     }
#   }
# }

# # page2
# resource "google_dialogflow_cx_page" "my_page2" {
#   parent       = google_dialogflow_cx_agent.tf_full_agent.start_flow
#   display_name = "MyPage2"
# }

# # asas
# resource "google_dialogflow_cx_webhook" "my_webhook" {
#   parent       = google_dialogflow_cx_agent.tf_full_agent.id
#   display_name = "MyWebhook"
#   generic_web_service {
#     uri = "https://example.com"
#   }
# }



# # resource "google_data_loss_prevention_inspect_template" "inspect" {
# #   parent       = "projects/my-project-name/locations/global"
# #   display_name = "dialogflowcx-inspect-template"
# #   inspect_config {
# #     info_types {
# #       name = "EMAIL_ADDRESS"
# #     }
# #   }
# # }

# # resource "google_data_loss_prevention_deidentify_template" "deidentify" {
# #   parent       = "projects/my-project-name/locations/global"
# #   display_name = "dialogflowcx-deidentify-template"
# #   deidentify_config {
# #     info_type_transformations {
# #       transformations {
# #         primitive_transformation {
# #           replace_config {
# #             new_value {
# #               string_value = "[REDACTED]"
# #             }
# #           }
# #         }
# #       }
# #     }
# #   }
# # }

# # # For export, i think
# # resource "google_storage_bucket" "bucket" {
# #   name                        = "dialogflowcx-bucket-log-out"
# #   location                    = "US"
# #   uniform_bucket_level_access = true
# # }

# # resource "google_dialogflow_cx_security_settings" "basic_security_settings" {
# #   display_name        = "dialogflowcx-security-settings"
# #   location            = "global"
# #   redaction_strategy  = "REDACT_WITH_SERVICE"
# #   redaction_scope     = "REDACT_DISK_STORAGE"
# #   inspect_template    = google_data_loss_prevention_inspect_template.inspect.id
# #   deidentify_template = google_data_loss_prevention_deidentify_template.deidentify.id
# #   purge_data_types    = ["DIALOGFLOW_HISTORY"]
# #   audio_export_settings {
# #     gcs_bucket             = google_storage_bucket.bucket.id
# #     audio_export_pattern   = "export"
# #     enable_audio_redaction = true
# #     audio_format           = "OGG"
# #   }
# #   insights_export_settings {
# #     enable_insights_export = true
# #   }
# #   retention_strategy = "REMOVE_AFTER_CONVERSATION"
# # }



# resource "google_dialogflow_cx_test_case" "basic_test_case" {
#   parent       = google_dialogflow_cx_agent.tf_full_agent.id
#   display_name = "MyTestCase"
#   tags         = ["#tag1"]
#   notes        = "demonstrates a simple training phrase response"

#   test_config {
#     tracking_parameters = ["some_param"]
#     page                = google_dialogflow_cx_page.basic_page.id
#   }

#   test_case_conversation_turns {
#     user_input {
#       input {
#         language_code = "en"
#         text {
#           text = "training phrase"
#         }
#       }
#       injected_parameters       = jsonencode({ some_param = "1" })
#       is_webhook_enabled        = true
#       enable_sentiment_analysis = true
#     }
#     virtual_agent_output {
#       session_parameters = jsonencode({ some_param = "1" })
#       triggered_intent {
#         name = google_dialogflow_cx_intent.basic_intent.id
#       }
#       current_page {
#         name = google_dialogflow_cx_page.basic_page.id
#       }
#       text_responses {
#         text = ["Training phrase response"]
#       }
#     }
#   }

#   test_case_conversation_turns {
#     user_input {
#       input {
#         event {
#           event = "some-event"
#         }
#       }
#     }
#     virtual_agent_output {
#       current_page {
#         name = google_dialogflow_cx_page.basic_page.id
#       }
#       text_responses {
#         text = ["Handling some event"]
#       }
#     }
#   }

#   test_case_conversation_turns {
#     user_input {
#       input {
#         dtmf {
#           digits       = "12"
#           finish_digit = "3"
#         }
#       }
#     }
#     virtual_agent_output {
#       text_responses {
#         text = ["I didn't get that. Can you say it again?"]
#       }
#     }
#   }
# }



