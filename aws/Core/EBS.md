# Elastic Block Storage

 These are storage volumes that you attach to Amazon EC2 instances. After you attach a volume to an instance, you can use it in the same way you would use a local hard drive attached to a computer, for example to store files or to install applications.

### Creating a Volume
We can create a volume with preferred settings in the volumes page and the `Volume must be created in the region of the ec2 instance only` and can be attached to the instance after creating from accessing the `Actions`button and attaching it .  

- In Linux we have options to name the volume like /dev/xdv[f-p] all other are there but f-p is recommended.
- Once attached we can see it in the volumes using `lsblk`  command.
Link for the documentation - https://docs.aws.amazon.com/ebs/latest/userguide/ebs-using-volumes.html
- The following is example output for a T2 instance. The root device is `/dev/xvda`, which has one partition named `xvda1`. The attached volume is `/dev/xvdf`, which has no partitions and is not yet mounted.
 ```shell
[ec2-user ~]$ lsblk 
NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT 
xvda 202:0 0 8G 0 disk 
-xvda1 202:1 0 8G 0 part / 
xvdf 202:80 0 10G 0 disk
```
- Use the **file -s** command to get information about a specific device, such as its file system type. If the output shows simply `data`, as in the following example output, there is no file system on the device
```shell
sudo file -s /dev/xvdf
```

- If the device has a file system, the command shows information about the file system type. For example, the following output shows a root device with the XFS file system.
```shell
[ec2-user ~]$  sudo file -s /dev/xvda1  
/dev/xvda1: SGI XFS filesystem data (blksz 4096, inosz 512, v2 dirs)
```
- If you have an empty volume, use the **mkfs -t** command to create a file system on the volume.
```shell
sudo mkfs -t xfs /dev/xvdf
```
- Mount the volume or partition at the mount point directory you created in the previous step. If the volume has no partitions, use the following command and specify the device name to mount the entire volume.
```shell
sudo mount /dev/xvdf /path/to/data
```

**The mount point is not automatically preserved after rebooting your instance.**

We can unmount any volume using the umount command .
```shell
sudo umount -d /dev/xdvf
```
### Automatically mount an attached volume after reboot

To mount an attached EBS volume on every system reboot, add an entry for the device to the `/etc/fstab` file. Read documentation.

## Amazon EBS snapshots
These are point-in-time backups of Amazon EBS volumes that persist independently from the volume itself. You can create snapshots to back up the data on your Amazon EBS volumes. You can then restore new volumes from those snapshots at any time.

You can back up the data on your Amazon EBS volumes by making point-in-time copies, known as _Amazon EBS snapshots_. A snapshot is an **incremental backup**, which means that we save only the blocks on the device that have changed since your most recent snapshot. This minimises the time required to create the snapshot and saves on storage costs by not duplicating data.

**`We can create a volume from a snapshot and can attach it to the instances and we need not format the volume and directly use it as it has a file system created for it already.`**
