# Terraform Overview

## Workspaces
Workspaces in Terraform are like environments (e.g., dev, prod, deploy, etc.) with unique names. Based on the workspace you're in, you can conditionally set variable values.

## Provisioners
Terraform can trigger provisioners during both resource creation and destruction. There are two main types of provisioners:

### `local-exec`
- **Local-exec provisioners** allow invoking local executable commands on the instance where the resources are created, after the resource is created.

### `remote-exec`
- **Remote-exec provisioners** allow invoking scripts directly on the remote server.

### Creation-Time Provisioners
- **Creation-time provisioners** are only run during resource creation, not during updates or any other lifecycle events.
- If a creation-time provisioner fails, the resource is marked as tainted.

### Destroy-Time Provisioners
- **Destroy-time provisioners** are run before the resource is destroyed.
- If `when = destroy` is specified, the provisioner will run when the resource it is defined within is destroyed.

### Handling Provisioner Failures
- By default, if a provisioner fails, the `terraform apply` process itself fails.
- The `on_failure` setting can be used to change this behavior:
  - **continue**: Ignore the error and continue with creation or destruction.
  - **fail**: Raise an error and stop applying (default behavior). If this is a creation provisioner, the resource is marked as tainted.

## Modules
Modules in Terraform are like functions where all the configurations for resources are written elsewhere and imported. They allow you to have hardcoded values or restrictions over resources. Modules can also have variables that override default values.

- Use the `module` block and specify the path for the module to use it.
- You can use **locals** to define variables within the module that cannot be overridden by the user who imports the module.
- **Output values** from modules can be used in your Terraform files.

### Module Sources
Modules can be sourced from various locations, including:
- Local Path
- GitHub
- Terraform Registry
- S3 Bucket
- HTTP URLs

## Terraform Registry
Terraform Registry is a registry for Terraform modules which can be imported into your configurations.

## .gitignore

### Files to Ignore

| File/Directory     | Description |
|--------------------|-------------|
| `.terraform`       | Recreated when `terraform init` is run. |
| `terraform.tfvars` | Likely to contain sensitive data like usernames/passwords and secrets. |
| `terraform.tfstate`| Should be stored remotely. |
| `crash.log`        | Logs stored if Terraform crashes. |

## Terraform Backend
A Terraform backend is where the state files and all the current infrastructure details are stored. Teams use these files to collaboratively work on Terraform projects.

- By default, the backend is local, but it can be one of the following:
  - S3
  - Consul
  - Azurerm
  - Kubernetes
  - HTTP
  - ETCD

### State Locking
State locking ensures the state file cannot be changed by more than one process at a time. By default, S3 does not support state locking, so you need to use a DynamoDB table to achieve this functionality.

## Terraform Remote State
The `terraform_remote_state` data source retrieves the root module output values from another Terraform configuration using the latest state snapshot from a remote backend. This is useful when you need to access data from another Terraform project's backend.

## Terraform Import
Terraform can automatically create the configuration files for resources you want to import.

- **Terraform 1.5** introduces automatic code generation for imported resources, dramatically reducing the time needed to write code to match the imported resources.
- This feature is not available in older versions of Terraform.
