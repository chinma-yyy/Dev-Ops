#!/bin/bash
# This script can be used for testing 
# and uniquely identifying the serber
# Use for Amazon Linux Image
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from the $(hostname -f)</h1>" > /var/www/html/index.html