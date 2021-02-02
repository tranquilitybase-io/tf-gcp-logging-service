# tf-gcp-logging

## Module overview

Terraform module which deploys GCP logging resources.

It deploys the following resources into a given GCP project:

- Creates GCS bucket logging
- Creates aggregated log export sinks, to export the filtered logs to dedicated GCS buckets
- Creates the export destination GCS buckets resource that will store all exported logs


## Usage

Refer to the examples under [examples/](examples) directory.

## Requirements

| Name | Version |
|------|---------|
| terraform | >=0.14.2,<0.15 |
| google | <4.0,>= 2.12 |

## Providers

| Name | Version |
|------|---------|
| google | <4.0,>= 2.12 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| applications\_bucket\_name | Name of the applications bucket | `string` | `"applications-folder-logs"` | no |
| applications\_folder\_id | Applications Folder Id in which the log export will be created | `string` | n/a | yes |
| applications\_log\_bucket\_labels | labels for applications folder audit logs export bucket | `map(string)` | <pre>{<br>  "function": "bucket-to-store-applications-folder-audit-logs"<br>}</pre> | no |
| applications\_log\_filter | Filter used for the application logging sink | `string` | `"logName:(-\"/logs/cloudaudit.googleapis.com%2Factivity\" AND -\"/logs/cloudaudit.googleapis.com%2Fdata_access\" AND -\"/logs/cloudaudit.googleapis.com%2Fsystem_event\")"` | no |
| applications\_sink\_name | Name of the applications sink. | `string` | `"applications_sink"` | no |
| bucket\_lifecycle\_rules | Lifecycle rules for logs. Defaults to moving from standard to nearline after 30 days and deleting after 365 | `list` | <pre>[<br>  {<br>    "action": {<br>      "storage_class": "NEARLINE",<br>      "type": "SetStorageClass"<br>    },<br>    "condition": {<br>      "age": "30"<br>    }<br>  },<br>  {<br>    "action": {<br>      "storage_class": null,<br>      "type": "Delete"<br>    },<br>    "condition": {<br>      "age": "365"<br>    }<br>  }<br>]</pre> | no |
| bucket\_location | Zone or region that the bucket will be created in | `string` | `"europe-west2"` | no |
| bucket\_storage\_class | Storage class for the bucket | `string` | `"REGIONAL"` | no |
| gcs\_logs\_bucket\_prefix | Prefix of the access logs & storage logs storage bucket | `string` | `"tb-bucket-access-storage-logs"` | no |
| iam\_members\_bindings | The list of IAM members to grant permissions for the logs bucket | <pre>list(object({<br>    role   = string,<br>    member = string<br>  }))</pre> | <pre>[<br>  {<br>    "member": "group:cloud-storage-analytics@google.com",<br>    "role": "roles/storage.legacyBucketWriter"<br>  }<br>]</pre> | no |
| shared\_services\_bucket\_name | Name of the shared services bucket | `string` | `"shared-services-folder-logs"` | no |
| shared\_services\_folder\_id | Shared Services Folder Id in which the log export will be created | `string` | n/a | yes |
| shared\_services\_log\_bucket\_labels | labels for shared services folder audit logs export bucket | `map(string)` | <pre>{<br>  "function": "bucket-to-store-shared-services-folder-audit-logs"<br>}</pre> | no |
| shared\_services\_log\_filter | Filter used for the shared services logging sink | `string` | `"logName:(-\"/logs/cloudaudit.googleapis.com%2Factivity\" AND -\"/logs/cloudaudit.googleapis.com%2Fdata_access\" AND -\"/logs/cloudaudit.googleapis.com%2Fsystem_event\")"` | no |
| shared\_services\_sink\_name | Name of the shared services sink | `string` | `"shared-services-sink"` | no |
| shared\_telemetry\_project\_id | The ID of the shared telemetry project in which storage bucket destination will be created | `string` | n/a | yes |
| tb\_discriminator | Random Id assigned to the deployment | `string` | n/a | yes |
| tb\_folder\_admin\_rw\_audit\_log\_bucket\_filter | TB folder admin read/write bucket audit logs filter | `string` | `"logName:(/logs/cloudaudit.googleapis.com%2Factivity OR /logs/cloudaudit.googleapis.com%2Fsystem_event)"` | no |
| tb\_folder\_admin\_rw\_audit\_log\_bucket\_labels | labels for tb folder audit logs export bucket | `map(string)` | <pre>{<br>  "function": "bucket-to-store-root-folder-audit-logs"<br>}</pre> | no |
| tb\_folder\_admin\_rw\_audit\_log\_bucket\_name | Bucket name for tb folder admin read/write bucket audit logs | `string` | `"tb-folder-admin-rw-audit-logs"` | no |
| tb\_folder\_admin\_rw\_audit\_log\_sink\_name | Log sink name for tb folder admin read/write bucket audit logs | `string` | `"tb-folder-admin-rw-audit-log-sink"` | no |
| tb\_folder\_root\_id | Id for the parent tb folder in which the log export will be created | `string` | n/a | yes |

## Outputs

No output.

