# EC2

Amazon EC2 allows you to create virtual machines, or instances, that run on the AWS Cloud.

## Amazon Machine Image

An AMI is a template that contains the software configuration (operating system, application server, and applications) required to launch your instance. 

## Accessing EC2 Instance

We can use key pair which is either .pem for OpenSSH or .ppk for Putty(Windows) or we can also connect to the Instance using EC2 Connect.

Example for SSH(Secure Socket Shell or Secure Shell)

```shell
chmod 400 "testSSH.pem"
ssh -i "testSSH.pem" ubuntu@ec2-18-212-172-140.compute-1.amazonaws.com
```

### User Data (Startup Script)

We can specify a startup script which runs on the initiation of the EC2 instance and can be used to setup nginx or something. 

## `Important Points to Note
- The script must not have any blank lines in it or else it will not will execute
- The logs will be stored in the `/var/log/cloud-init-output.log` file
- The script will run only when it instantiates not when it is rebooted or not even when the instance is created using AMI.
- The script is not run interactively, you cannot include commands that require user feedback
## Security group

Create security group which has specific inbound and outbound rules for HTTP and HTTPS and for SSH keep open port 22

# EBS volumes(Elastic Block Store)

