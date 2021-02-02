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

variable "region" {
  description = "Region name"
  type        = string
  default     = "europe-west2"
}

variable "project_id" {
  description = "The ID of the project in which storage bucket destination will be created"
  type        = string
  default     = "shared_telemetry_id"
}

variable "tb_discriminator" {
  type        = string
  description = "Random Id assigned to the deployment"
}

variable "tb_folder_root_id" {
  type        = string
  description = "Id for the parent tb folder in which the log export will be created"
  default     = "rootId"
}

variable "applications_folder_id" {
  description = "Applications Folder Id in which the log export will be created"
  type        = string
  default     = "activators_id"
}

variable "shared_services_folder_id" {
  type        = string
  description = "Shared Services Folder Id in which the log export will be created"
  default     = "shared_services_id"
}