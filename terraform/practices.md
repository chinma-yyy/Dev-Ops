We can have workspaces it is like an environment with a name and based on the workspace we are working we can conditionally setup the values of our variablelike for dev prod deploy etc.

Provisioners
Terraform has capability to turn provisioners both at the time of resource creation as well as
destruction.
There are two main types of provisioners:
local-exec
local-exec provisioners allow us to invoke local executable commands on the instance from where the resources are created after resource is created.
remote-exec
Remote-exec provisioners allow to invoke scripts directly on the remote server.

Creation-Time ProvisionerCreation-time provisioners are only run during creation,
not during updating or any other lifecycle
If a creation-time provisioner fails, the resource is
marked as tainted.
Destroy-Time Provisioner
Destroy provisioners are run before the resource is
destroyed.

If when = destroy is specified, the provisioner will run when the resource it is defined within is
destroyed.

By default, provisioners that fail will also cause the terraform apply itself to fail.
The on_failure setting can be used to change this.
continue Ignore the error and continue with creation or destruction.
fail Raise an error and stop applying (the default behavior). If this is a
creation provisioner, taint the resource.

Modules
it is like all the configuration for the resources are written elsewhere and imported and then the code is used through which we can have some hardcoded values or restrictions over the resource it is just like a function and we can have variables also to override the default values. we need to use the module block and specify the path for the module to use it.

using locals 
we can use locals to only have the variables in the tf file and which can not be overriden by the user who imports the module

we can also use the output values from the modules in our tf files

terraform registry is registry for these modules which we can use to import 

If we intend to use a module, we need to define the path where the module files are present.
The module files can be stored in multiple locations, some of these include:
Local Path
GitHub
Terraform Registry
S3 Bucket
HTTP URLs

.gitgnore
Files to IgnoreDescription
.terraformThis file will be recreated when terraform init is run.
terraform.tfvarsLikely to contain sensitive data like usernames/passwords and secrets.
terraform.tfstateShould be stored in the remote side.
crash.logIf terraform crashes, the logs are stored to a file named crash.log


Terraform backend
so it is the location where the state files and alll the current infrastructure details are stored and then all the team uses these files to collaboratively work on terraform 
by default this backend is local and can be a 
S3
Consul
Azurerm
Kubernetes
HTTP
ETCD

State locaking is basically lock to the file so state can not be changed.
By default, S3 does not support State Locking functionality.
You need to make use of DynamoDB table to achieve state locking functionality.



Terraform remote state 
so if there are multiple terraform projects and we want some data from the backend from any other backend thenwe can use the this.The terraform_remote_state data source retrieves the root module output values from some
other Terraform configuration, using the latest state snapshot from the remote backend.

terraform import can automatically create the terraform
configuration files for the resources you want to import.
Terraform 1.5 introduces automatic code generation for imported resources.
This dramatically reduces the amount of time you need to spend writing code to
match the imported
This feature is not available in the older version of Terraform.