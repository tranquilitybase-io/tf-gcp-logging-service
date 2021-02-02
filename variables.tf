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

variable "shared_telemetry_project_id" {
  description = "The ID of the shared telemetry project in which storage bucket destination will be created"
  type        = string
}

variable "tb_discriminator" {
  description = "Random Id assigned to the deployment"
  type        = string
}

variable "gcs_logs_bucket_prefix" {
  description = "Prefix of the access logs & storage logs storage bucket"
  type        = string
  default     = "tb-bucket-access-storage-logs"
}

variable "iam_members_bindings" {
  description = "The list of IAM members to grant permissions for the logs bucket"
  type = list(object({
    role   = string,
    member = string
  }))
  default = [{
    role   = "roles/storage.legacyBucketWriter",
    member = "group:cloud-storage-analytics@google.com"
  }]
}

variable "bucket_lifecycle_rules" {
  description = "Lifecycle rules for logs. Defaults to moving from standard to nearline after 30 days and deleting after 365"
  default = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      },
      condition = {
        age = "30"
      }
    },
    {
      action = {
        type          = "Delete"
        storage_class = null
      },
      condition = {
        age = "365"
      }
    }
  ]
}

variable "bucket_storage_class" {
  description = "Storage class for the bucket"
  type        = string
  default     = "REGIONAL"
}

variable "bucket_location" {
  description = "Zone or region that the bucket will be created in"
  type        = string
  default     = "europe-west2"
}

variable "tb_folder_root_id" {
  description = "Id for the parent tb folder in which the log export will be created"
  type        = string
}

variable "tb_folder_admin_rw_audit_log_bucket_filter" {
  description = "TB folder admin read/write bucket audit logs filter"
  default     = "logName:(/logs/cloudaudit.googleapis.com%2Factivity OR /logs/cloudaudit.googleapis.com%2Fsystem_event)"
  type        = string
}

variable "tb_folder_admin_rw_audit_log_bucket_name" {
  description = "Bucket name for tb folder admin read/write bucket audit logs"
  type        = string
  default     = "tb-folder-admin-rw-audit-logs"
}

variable "tb_folder_admin_rw_audit_log_sink_name" {
  description = "Log sink name for tb folder admin read/write bucket audit logs"
  default     = "tb-folder-admin-rw-audit-log-sink"
  type        = string
}

variable "tb_folder_admin_rw_audit_log_bucket_labels" {
  description = "labels for tb folder audit logs export bucket"
  type        = map(string)
  default     = { "function" = "bucket-to-store-root-folder-audit-logs" }
}

variable "applications_folder_id" {
  description = "Applications Folder Id in which the log export will be created"
  type        = string
}

variable "applications_sink_name" {
  description = "Name of the applications sink."
  type        = string
  default     = "applications_sink"
}

variable "applications_log_filter" {
  description = "Filter used for the application logging sink"
  type        = string
  default     = "logName:(-\"/logs/cloudaudit.googleapis.com%2Factivity\" AND -\"/logs/cloudaudit.googleapis.com%2Fdata_access\" AND -\"/logs/cloudaudit.googleapis.com%2Fsystem_event\")"
}

variable "applications_bucket_name" {
  description = "Name of the applications bucket"
  type        = string
  default     = "applications-folder-logs"
}

variable "applications_log_bucket_labels" {
  description = "labels for applications folder audit logs export bucket"
  type        = map(string)
  default     = { "function" = "bucket-to-store-applications-folder-audit-logs" }
}

variable "shared_services_folder_id" {
  description = "Shared Services Folder Id in which the log export will be created"
  type        = string
}

variable "shared_services_sink_name" {
  description = "Name of the shared services sink"
  type        = string
  default     = "shared-services-sink"
}

variable "shared_services_log_filter" {
  description = "Filter used for the shared services logging sink"
  type        = string
  default     = "logName:(-\"/logs/cloudaudit.googleapis.com%2Factivity\" AND -\"/logs/cloudaudit.googleapis.com%2Fdata_access\" AND -\"/logs/cloudaudit.googleapis.com%2Fsystem_event\")"
}

variable "shared_services_bucket_name" {
  description = "Name of the shared services bucket"
  type        = string
  default     = "shared-services-folder-logs"
}

variable "shared_services_log_bucket_labels" {
  description = "labels for shared services folder audit logs export bucket"
  type        = map(string)
  default     = { "function" = "bucket-to-store-shared-services-folder-audit-logs" }
}