# Terraform Commands

## Terraform Plan
The `terraform plan` command checks what resources have been created and what resources must be created, along with their respective settings. This command should be run before actually provisioning any infrastructure.

### Usage
```sh
terraform plan
```

### Options
- **`-out=path`**: Save the generated Terraform plan to a specified path. This plan can then be used with `terraform apply` to ensure that only the changes shown in this plan are applied. This is useful for creating an image of the infrastructure for future use.
- **`-refresh=false`**: Prevent Terraform from querying the current state during operations like `terraform plan`.
- **`-target=resource`**: Target a specific resource. This is generally used to operate on isolated portions of very large configurations.

### Example
```sh
terraform plan -out=plan.tfplan
terraform plan -refresh=false
terraform plan -target=aws_instance.example
```

## Terraform Apply
The `terraform apply` command provisions all the infrastructure and modifies the settings of any existing infrastructure if changes are detected. If any setting changes for a particular resource, Terraform will modify the current resource rather than creating a new one. All resources are tracked in the Terraform state file.

### Usage
```sh
terraform apply
```

### Options
- **`-replace`**: Force Terraform to replace an object even if there are no configuration changes that require it. This is generally not recommended, but it can be useful in certain situations.

### Example
```sh
terraform apply
terraform apply -replace="aws_instance.web"
```

### Logging
Terraform provides detailed logs that can be enabled by setting the `TF_LOG` environment variable to any value. You can set `TF_LOG` to one of the log levels `TRACE`, `DEBUG`, `INFO`, `WARN`, or `ERROR` to control the verbosity of the logs. To persist log output, set `TF_LOG_PATH` to specify a file to which logs should be appended when logging is enabled.

## Terraform Format
The `terraform fmt` command is used to rewrite Terraform configuration files to ensure consistent formatting.

### Usage
```sh
terraform fmt
```

## Terraform Validate
The `terraform validate` command checks whether a configuration is syntactically valid. It can detect issues like unsupported arguments, undeclared variables, and other potential errors.

### Usage
```sh
terraform validate
```

## Terraform Graph
The `terraform graph` command generates a visual representation of either a configuration or an execution plan. The output is in DOT format, which can be converted to an image using various tools.

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

## Terraform State Management
As your Terraform usage becomes more advanced, you may need to modify the Terraform state. It is important never to modify the state file directly. Instead, use the `terraform state` command.

### State Subcommands

| Command         | Description                                                      |
|-----------------|------------------------------------------------------------------|
| `list`          | List resources within the Terraform state file.                  |
| `mv`            | Move items within the Terraform state.                           |
| `pull`          | Manually download and output the state from the remote backend.  |
| `push`          | Manually upload a local state file to the remote backend.        |
| `rm`            | Remove items from the Terraform state.                           |
| `show`          | Show the attributes of a single resource in the state.           |

### Terraform State `mv`
The `terraform state mv` command is used to move items within a Terraform state file. This command is useful when you want to rename an existing resource without destroying and recreating it. Due to the potentially destructive nature of this command, Terraform will output a backup copy of the state before saving any changes.
