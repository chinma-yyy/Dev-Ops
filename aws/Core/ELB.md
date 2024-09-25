# AWS Load Balancers

### 1. Application Load Balancer (ALB)
 ALB operates at the application layer (OSI model layer 7) and is designed to handle HTTP and HTTPS traffic. It provides advanced routing capabilities, including path-based and host-based routing.
 • Each subnet must have a min of /27 and 8 free IP addresses
• Across all subnets, a maximum of 100 IP addresses will be used per ALB
 
### ALB Stickiness (Session Affinity)
Ensures that user sessions are consistently routed to the same target.
Utilizes cookies to track sessions. When a user makes a request, the load balancer inserts a cookie into the response, and subsequent requests with the same cookie are routed to the same target.
The sticker name is AWSALBAPP , AWSELB etc. which are reserved by AWS and must not be used in the application.
The stickiness duration is from 1-7 days.
### Cross-Zone Load Balancing
Distributes incoming traffic evenly across all targets in all enabled Availability Zones.
Provides a more balanced load distribution and improves application availability and resilience.

### SSL Certificates
 Secure data in transit between clients and load balancers. AWS Certificate Manager (ACM) can be used to provision, manage, and deploy SSL/TLS certificates. ALBs and NLBs support SSL/TLS termination, which decrypts the traffic before sending it to the target instances.

### Connection Draining (Deregistration Delay)
- **Purpose**: Ensures smooth removal of instances from the load balancer by allowing existing connections to complete before deregistering the instance.
- **How It Works**: When an instance is deregistered or marked unhealthy, new connections are not sent to the instance, but existing connections are allowed to finish.
### 2. Network Load Balancer (NLB)
 NLB operates at the transport layer (OSI model layer 4) and is designed to handle TCP, UDP, and TLS traffic. It is optimized for high-performance and low-latency traffic.
 • NLB has one static IP per AZ, and suppor ts
assigning Elastic IP (Internet-facing NLB)
(helpful for whitelisting specific IP addresses)
• Client IP Preservation: client IP is forwarded to targets
• Targets by instance ID / ECS Tasks: Enabled
• Targets by IP address TCP & TLS: Disabled by default
• Targets by IP address UDP & TCP_UDP: Enabled by default
• You must enable an AZ before traffic is sent
to that AZ (can be added after NLB
creation)
• Cross Zones Load Balancing only works for
the availability zones that are enabled on the
NLB
• You cannot remove an AZ after it is enabled
• Resolving Regional NLB DNS name returns
the IP addresses of ENIs for all NLB nodes in all
enabled AZs
For internet-facing load balancers, the subnets that you specify must have at
least 8 available IP addresses (e.g. min /28).
### 3. Global Load Balancer (GLB)
 AWS Global Accelerator provides a single entry point to your applications and optimizes traffic routing globally. It's not strictly a traditional load balancer but offers global traffic management.


# Auto Scaling Groups (ASG) in AWS

Auto Scaling Groups are used to automatically adjust the number of EC2 instances in your application based on specific conditions, such as CPU usage and other metrics. This ensures that you have the right amount of resources to handle the load for your application.

### Launch Template
A launch template specifies the configuration for your EC2 instances. This includes the Amazon Machine Image (AMI), instance type, key pair, security groups, and other settings.

### Steps to Create an ASG

1. **Create ASG**: 
   - Name your ASG and select a version.
   - Add the launch template for the default configuration.

2. **Select VPC and Availability Zones**:
   - Choose the VPC and Availability Zones where your instances will run.
   - You can override the instance types specified in the launch template based on certain conditions.

3. **Configure Load Balancer and Health Checks**:
   - Attach a load balancer to distribute traffic across your instances.
   - Set up health checks to monitor the status of instances.

4. **Set Scaling Size**:
   - Define the desired capacity, minimum, and maximum number of instances for the ASG.

## Scaling Policies

ASG supports various policies to scale instances automatically. You can configure multiple policies for an ASG.

### 1. Scheduled Actions
Scale your instances based on a predetermined schedule.
  - Schedule a period when you expect traffic to increase or decrease.
  - Configure the desired minimum and maximum capacity for the scheduled period.
  - This can be set for a one-time event or recurring events (daily, weekly, or using a custom cron schedule).

### 2. Predictive Scaling Policy
Use machine learning to predict future traffic and scale instances accordingly.
  - AWS analyzes historical data to forecast future traffic patterns.
  - Automatically scales instances up or down based on predicted needs.
  - Helps to ensure that your application has the capacity to handle expected loads without manual intervention.

### 3. Dynamic Scaling Policies
Automatically adjust the number of instances in response to changes in demand.
### Types
1. **Target Tracking Scaling**
Target Tracking Scaling adjusts the number of instances to maintain a specific target value for a predefined metric, such as average CPU utilization or request count per target. It works similarly to a thermostat, where the goal is to maintain a target value. There is a cooldown period which is started when an instance comes up or comes down during that period the metric is allowed to adjust and after that time only based on the metric the scaling takes place.
- **Define a Target Value**: You specify a target value for a specific metric (e.g., keeping CPU utilization at 50%).
- **Automatic Adjustments**: ASG automatically increases or decreases the number of instances to keep the metric as close to the target value as possible.
- **Example Use Case**: Maintaining CPU utilization at a steady level to ensure performance without over-provisioning resources.

2. **Step Scaling**
Step Scaling allows you to add or remove instances in steps based on a set of scaling thresholds. This method provides more control over scaling actions and can be configured to respond to different levels of demand with different actions.
- **`Define Scaling Thresholds`**: **You set multiple thresholds for a metric, with each threshold having a corresponding scaling action**.
- **Scaling Actions**: When a threshold is crossed, the ASG performs a predefined scaling action (e.g., adding two instances if CPU utilization exceeds 70%).
- **Granular Control**: Allows for more granular and incremental adjustments compared to simple scaling.

3. **Simple Scaling**
Simple Scaling is a straightforward approach where a fixed number of instances are added or removed based on a single scaling adjustment. It is easier to configure but less flexible compared to step scaling.
- **Define a Scaling Adjustment**: You specify a metric and a single scaling adjustment (e.g., add three instances if CPU utilization exceeds 80%).
- **Trigger Action**: When the specified metric crosses the threshold, the ASG performs the scaling adjustment.
- **Example Use Case**: Quick and simple scaling needs where detailed control is not necessary.

We can have rules in the alb where we specify which requests to forward and redirect to different hosts on the conditions of headers or other http request details
