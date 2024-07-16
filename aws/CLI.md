# CLI
We can use the dry run flag in aws cli to not exactly execute the command but to test it that if it will owrk or not .

If it gives an error then an hash will be printed and which can be decode to get the error message using the command. to execute the command the iam policy should have the respective policy.

we can also create profiles for using multiple aws accounts

EC2 Instance Metadata (IMDS)
• AWS EC2 Instance Metadata (IMDS) is powerful but one of the least known
features to developers
• It allows AWS EC2 instances to ”learn about themselves” without using an
IAM Role for that purpose.
• The URL is http://169.254.169.254/latest/meta-data
• IMDSv1 is accessing http://169.254.169.254/latest/meta-data directly
• IMDSv2 is more secure and is done in two steps:
1. Get Session Token (limited validity) – using headers & PUT
2. Use Session Token in IMDSv2 calls – using headers