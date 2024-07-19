# Terraform Commands

## Terraform Plan
The `terraform plan` command checks what resources are created and what resources must be created with what settings. It must be run before actually bringing up any infrastructure.

### Usage
```sh
terraform plan
```

### Options
- **-out=path**: The generated terraform plan can be saved to a specific path. This plan can then be used with `terraform apply` to ensure that only the changes shown in this plan are applied. This can be used to create an image for the infrastructure and use it in the future.
- **-refresh=false**: Prevents Terraform from querying the current state during operations like `terraform plan`.
- **-target=resource**: Targets a specific resource. This is generally used to operate on isolated portions of very large configurations.

### Example
```sh
terraform plan -out=plan.tfplan
terraform plan -refresh=false
terraform plan -target=aws_instance.example
```

## Terraform Apply
The `terraform apply` command brings up all the infrastructure and modifies the settings of any existing infrastructure if changes are detected. If any setting is changed for a particular resource, it will not create a new resource but will modify the current resource. All the resources are tracked in the Terraform state file.

### Usage
```sh
terraform apply
```

### Options
- **-replace**: Forces Terraform to replace an object even if there are no configuration changes that would require it. It is not a good practice to use it, but it can be useful in certain cases.

### Example
```sh
terraform apply
terraform apply -replace="aws_instance.web"
```

### Logging
Terraform has detailed logs which can be enabled by setting the `TF_LOG` environment variable to any value. You can set `TF_LOG` to one of the log levels `TRACE`, `DEBUG`, `INFO`, `WARN`, or `ERROR` to change the verbosity of the logs. To persist logged output, you can set `TF_LOG_PATH` to force the log to always be appended to a specific file when logging is enabled.

## Terraform Format
The `terraform fmt` command is used to rewrite Terraform configuration files to take care of the overall formatting.

### Usage
```sh
terraform fmt
```

## Terraform Validate
`Terraform validate` primarily checks whether a configuration is syntactically valid. It can check various aspects including unsupported arguments, undeclared variables, and others.

### Usage
```sh
terraform validate
```

## Terraform Graph
The `terraform graph` command is used to generate a visual representation of either a configuration or execution plan. The output of `terraform graph` is in the DOT format, which can easily be converted to an image.

### Usage
```sh
terraform graph
```

## Terraform Output
The `terraform output` command is used to extract the value of an output variable from the state file.

### Usage
```sh
terraform output
```