## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acl | Canned ACL to apply to the S3 bucket | string | `log-delivery-write` | no |
| attributes | Additional attributes (e.g. `logs`) | list(string) | `<list>` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| enabled | Set to `false` to prevent the module from creating any resources | bool | `true` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | string | `` | no |
| force_destroy | A boolean that indicates the bucket can be destroyed even if it contains objects. These objects are not recoverable | bool | `false` | no |
| lifecycle_prefix | Prefix filter. Used to manage object lifecycle events | string | `` | no |
| name | Name  (e.g. `app` or `cluster`) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | `` | no |
| region | AWS Region for S3 bucket | string | - | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | `` | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_arn | S3 bucket ARN |
| bucket_domain_name | S3 bucket domain name |
| bucket_id | S3 bucket ID |
| bucket_prefix | S3 bucket prefix |

