## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 2.0 |
| local | ~> 1.2 |
| null | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acl | Canned ACL to apply to the S3 bucket | `string` | `"log-delivery-write"` | no |
| attributes | Additional attributes (e.g. `logs`) | `list(string)` | `[]` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| enabled | Set to `false` to prevent the module from creating any resources | `bool` | `true` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| force\_destroy | A boolean that indicates the bucket can be destroyed even if it contains objects. These objects are not recoverable | `bool` | `false` | no |
| lifecycle\_prefix | Prefix filter. Used to manage object lifecycle events | `string` | `""` | no |
| lifecycle\_rule\_enabled | A boolean that indicates whether the s3 log bucket lifecycle rule should be enabled. | `bool` | `false` | no |
| name | Name  (e.g. `app` or `cluster`) | `string` | n/a | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | `string` | `""` | no |
| region | AWS Region for S3 bucket | `string` | n/a | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | `""` | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_arn | S3 bucket ARN |
| bucket\_domain\_name | S3 bucket domain name |
| bucket\_id | S3 bucket ID |
| bucket\_prefix | S3 bucket prefix |

