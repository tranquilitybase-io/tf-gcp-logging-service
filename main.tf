# Copyright 2021 The Tranquility Base Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {
  tb_folder_root_id         = "${var.tb_folder_admin_rw_audit_log_bucket_name}-${var.tb_discriminator}"
  applications_bucket_id    = "${var.applications_bucket_name}-${var.tb_discriminator}"
  shared_services_bucket_id = "${var.shared_services_bucket_name}-${var.tb_discriminator}"
  gcs_logs_bucket_id        = "${var.gcs_logs_bucket_prefix}-${var.tb_discriminator}"
}

##
# Create GCS bucket logging
##

module "gcs_bucket_logging" {
  source          = "github.com/tranquilitybase-io/terraform-google-cloud-storage.git//modules/simple_bucket?ref=logging-v3"
  name            = local.gcs_logs_bucket_id
  project_id      = var.shared_telemetry_project_id
  iam_members     = var.iam_members_bindings
  location        = var.bucket_location
  storage_class   = var.bucket_storage_class
  lifecycle_rules = var.bucket_lifecycle_rules
}

##
# Create an aggregated log export sink on the tb folder level
##

module "tb-folder-log-export" {
  source               = "terraform-google-modules/log-export/google"
  version              = "~> 5.1.0"
  destination_uri      = "storage.googleapis.com/${module.tb-folder-log-bucket.name}"
  filter               = var.tb_folder_admin_rw_audit_log_bucket_filter
  log_sink_name        = var.tb_folder_admin_rw_audit_log_sink_name
  parent_resource_id   = var.tb_folder_root_id
  parent_resource_type = "folder"
  include_children     = true
}

##
# Create the export destination that will store all activity and system_events cloud audit logs
##

module "tb-folder-log-bucket" {
  source          = "github.com/tranquilitybase-io/terraform-google-cloud-storage.git//modules/simple_bucket?ref=logging-v3"
  project_id      = var.shared_telemetry_project_id
  name            = local.tb_folder_root_id
  location        = var.bucket_location
  storage_class   = var.bucket_storage_class
  lifecycle_rules = var.bucket_lifecycle_rules
  labels          = var.tb_folder_admin_rw_audit_log_bucket_labels
  log_bucket      = module.gcs_bucket_logging.name
}

resource "google_storage_bucket_iam_binding" "storage_sink_member_tb" {
  bucket  = module.tb-folder-log-bucket.name
  role    = "roles/storage.objectCreator"
  members = [module.tb-folder-log-export.writer_identity]
}

##
# Create an aggregated log export sink on the applications folder level
##

module "applications-log-export" {
  source               = "terraform-google-modules/log-export/google"
  version              = "~> 5.1.0"
  destination_uri      = "storage.googleapis.com/${module.applications-log-bucket.name}"
  filter               = var.applications_log_filter
  log_sink_name        = var.applications_sink_name
  parent_resource_id   = var.applications_folder_id
  parent_resource_type = "folder"
  include_children     = true
}

##
# Create the applications export destination that will store all activity, data access and system_events cloud audit logs
##

module "applications-log-bucket" {
  source          = "github.com/tranquilitybase-io/terraform-google-cloud-storage.git//modules/simple_bucket?ref=logging-v3"
  project_id      = var.shared_telemetry_project_id
  name            = local.applications_bucket_id
  location        = var.bucket_location
  storage_class   = var.bucket_storage_class
  lifecycle_rules = var.bucket_lifecycle_rules
  labels          = var.applications_log_bucket_labels
  log_bucket      = module.gcs_bucket_logging.name
}

resource "google_storage_bucket_iam_binding" "storage_sink_member_app" {
  bucket  = module.applications-log-bucket.name
  role    = "roles/storage.objectCreator"
  members = [module.applications-log-export.writer_identity]
}

##
# Create an aggregated log export sink on the shared services folder level
##

module "shared-services-log-export" {
  source               = "terraform-google-modules/log-export/google"
  version              = "~> 5.1.0"
  destination_uri      = "storage.googleapis.com/${module.shared-services-log-bucket.name}"
  filter               = var.shared_services_log_filter
  log_sink_name        = var.shared_services_sink_name
  parent_resource_id   = var.shared_services_folder_id
  parent_resource_type = "folder"
  include_children     = true
}

##
# Create the shared services export destination that will store all activity, data access and system_events cloud audit logs
##

module "shared-services-log-bucket" {
  source          = "github.com/tranquilitybase-io/terraform-google-cloud-storage.git//modules/simple_bucket?ref=logging-v3"
  project_id      = var.shared_telemetry_project_id
  name            = local.shared_services_bucket_id
  location        = var.bucket_location
  storage_class   = var.bucket_storage_class
  lifecycle_rules = var.bucket_lifecycle_rules
  labels          = var.shared_services_log_bucket_labels
  log_bucket      = module.gcs_bucket_logging.name
}

resource "google_storage_bucket_iam_binding" "storage_sink_member_ss" {
  bucket  = module.shared-services-log-bucket.name
  role    = "roles/storage.objectCreator"
  members = [module.shared-services-log-export.writer_identity]
}