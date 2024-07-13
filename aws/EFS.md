# Elastic File System

EFS is a shared file system in AWS which scales automatically on the storage block and the io speed required and it is available in a region among all az.

It is created once and can be mounted to a specific location in an ec2 instance during the instantiation of the instance and can be mounted to multiple instances and is in sync with each other. All the mounting and attaching is done by the service.
**`The EFS needs a protocol of NFS on port 2049`**


![[Pasted image 20240713155451.png]]
