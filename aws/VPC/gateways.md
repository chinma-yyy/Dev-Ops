## VPC Peering

- VPC peering is a method through which we can connect with multiple VPCs, which are in the same regions, in different regions, and also in different AWS accounts.
- We can directly go in the VPC peering option and send a request to a VPC and then accept it from the other VPC.
- There is no transitivity in VPC peering, and we cannot have a connection to a VPC from a VPC which is in between.
- The CIDR blocks for both must be different.

## VPC Endpoint

- For using AWS services from private instances, we need not have a NAT gateway. We can create a VPC endpoint, which is attached to the VPC, and the VPC endpoint can access the AWS resource for the private instance.

### Two Types of Endpoint:

- **Gateway Endpoint** is for DynamoDB and S3.
  - When we create an Amazon S3 endpoint, a prefix list is created in VPC.
  - The prefix list is the collection of IP addresses that Amazon S3 uses.
  - The Prefix list is formatted as pl-xxxxxxxx and becomes an available option in both subnet routing tables and security groups.
  - We need to have a perfect IAM role for the EC2 private instance, which is accessing the VPC endpoint.
  - The route table should allow access to the VPC endpoint.
  - Access is gained using the prefix list generated for S3, a list of IP addresses for the S3.
  - We also have to allow the S3 bucket policy for inbound traffic and the security group of the EC2 private instance for outbound rules.
  - Here, transitivity is not supported like VPC peering.

- **Interface Endpoint**
  - We can use other services, except S3 and DynamoDB, from AWS with the help of an interface endpoint.
  - We can provide access to other VPC SaaS applications.
  - Unlike VPC peering, we will only give access to the ELB in front of the app.
  - It is powered by PrivateLink.
  - Interface endpoints create local IP addresses (using ENI) in your VPC.
  - You create one interface endpoint per Availability Zone for high availability.
  - Uses Security Groups – inbound rules.
  - For interface endpoints, AWS creates Regional and zonal DNS entries that resolve to the private IP address of the interface endpoint.
  - Interface endpoint supports only IPv4 traffic.
  - Interface VPC endpoints support traffic only over TCP.

## Endpoint Services

- These are basically the ALBs mentioned above, which we need to create to attach to the interface endpoint.
- With this service, the interface endpoint can now access the service from another VPC.

- Since this interface endpoint creates an ENI, the connection is transitive, meaning that we can access the service in VPC C from VPC A, with VPC B in between. However, the private DNS cannot be resolved from VPC A, which is either a VPC or on-premise cloud.

- VPC peering is useful when there are many resources that should communicate between peered VPCs.
- PrivateLink should be used when you want to allow access to only a single application hosted in your VPC to other VPCs without peering the VPCs.
- When there are overlapping CIDRs, a VPC peering connection cannot be created. However, PrivateLink does support overlapping CIDR.
- We can create a maximum of 125 peering connections. There is no limit on PrivateLink connections.
- VPC peering enables bidirectional traffic origin. PrivateLink allows only the consumer to originate the traffic.
# AWS Transit Gateway

AWS Transit Gateway is a network transit hub that enables you to connect your Amazon Virtual Private Clouds (VPCs) and on-premises networks through a central gateway. It allows for the creation of a full service mesh between VPCs, VPNs, and on-premises networks, enabling efficient and scalable network management.

## Key Features

### 1. Transitivity Between VPCs
   - Transit Gateway provides transitive routing between VPCs, VPNs, and Direct Connect gateways. This allows you to create a full mesh of connections where VPCs can communicate with each other through the Transit Gateway.

### 2. Peering Between Transit Gateways
   - Just like VPC peering, Transit Gateways can be peered across different AWS Regions, enabling global connectivity for your networks.

### 3. Connecting On-Premises Networks
   - You can connect on-premises networks to AWS using a VPN or Direct Connect attached to the Transit Gateway, integrating your on-premises infrastructure with your AWS cloud environment.

## Configuration and Management

### 1. Non-Overlapping CIDR Blocks
   - Ensure that VPCs connected to the Transit Gateway do not have overlapping CIDR blocks to avoid routing conflicts.

### 2. Default Route Table
   - When a Transit Gateway is created, it comes with a default route table that gets associated with all attachments. This route table allows all traffic between connected VPCs by default.
   - The default route table can be disabled if needed.

### 3. Transit Gateway Attachments
   - Attachments are created for each VPC, VPN, or Direct Connect connection to the Transit Gateway. Each attachment can be associated with specific route tables to control the routing between VPCs.

### 4. Transit Attachment Route Tables
   - You can create multiple transit attachment route tables to manage traffic between VPCs. These route tables are used to define which VPCs can communicate with each other, similar to subnet route tables.
   - Associations and propagations are used to configure these tables:
     - **Associations**: Determine which VPCs (attachments) are allowed to access specific route tables.
     - **Propagations**: Automatically propagate routes to the transit route tables, reflecting the CIDR ranges of the connected VPCs.

## Traffic Management

- **Association Management**: Create associations for route tables to specify the traffic routing rules for each VPC attachment.
- **Propagation Management**: Propagations monitor CIDR blocks in VPCs and add them to the route tables to ensure all network segments are routable.
- **Route Visibility**: View and manage routes within the transit route tables to ensure correct traffic flow between VPCs.

## Use Cases

- **Multi-VPC Environments**: Efficiently manage and route traffic between multiple VPCs in a hub-and-spoke model.
- **Hybrid Cloud Connectivity**: Seamlessly integrate on-premises networks with AWS using VPN or Direct Connect.
- **Global Network Management**: Use peering between Transit Gateways for global connectivity across different AWS regions.

Transit gateway az affinity
so what happens is when a transit gateway takes a traffic from any vpc it has enis in specific azs and these eni can connect to other azs but transit gateways attempt to keep the traffic in the originating az and if not then connects to the other az but then again while returnign the traffic it attemots to keep the traffic in that same az which az2 and now this would result in not giving the origin the traffic back and in errors in a statefull application

![[Pasted image 20240809123234.png]]

Here we can see in the second vpc the traffic is not delivered correctly we can then use appliance mode which uses hashing and delivers traffic correctly.

• You can create a transit gateway Connect attachment to establish a connection
between a transit gateway and third-party virtual appliances (such as SD-WAN
appliances) running in a VPC
• A Connect attachment uses an existing VPC or AWS Direct Connect attachment as
the underlying transport mechanism.
• Supports Generic Routing Encapsulation (GRE) tunnel protocol for high
performance, and Border Gateway Protocol (BGP) for dynamic routing.
![[Pasted image 20240809172658.png]]

Multicast
Multicast is a communication protocol used for delivering a single stream of
data to multiple receiving computers simultaneously.
• Destination is a multicast group address:
• Class D - 224.0. 0.0 to 239.255. 255.255
One way communication
Multicast components
• Multicast Domain
• Multicast Group and member
• Multicast source and receivers
• Internet Group Management Protocol (IGMP)
so multicast can be enabled on the tansit gateway and we need class d ip cidr but we cannot explicitly allot them so we crreate a multicast domain . the instacnes use igmp protocol for joining and leaving the group and the security group and acl policies must also be modified allowing this protocol 
The source IP of these IGMP query packets is 0.0.0.0/32, destination IP is 224.0.0.1/32
and the protocol is IGMP(2).
Multicast routing is not supported over AWS Direct Connect, Site-to-Site VPN, TGW
peering attachments, or transit gateway Connect attachments.

centralized egress transit gateway 
![[Pasted image 20240809173414.png]]

in this image we can see that all the traffic to the internet goes through the transit gateway to the vpc b and then through the nat gateway and there is no  inter vpc connection using this way we can have a centralized egress only gatewya thrigh which we can also implement ids and also monitor the traffic.
![[Pasted image 20240809173643.png]]
similarly in this image we are using gateway load balancer for the same and inspecting the trtaffic we can also see the path of the traffic
and if we attach a nat ahead it again gets like the same as before with glwb

• Using AWS PrivateLink, GWLB Endpoint routes traffic to GWLB. Traffic is routed securely over
Amazon network without any additional configuration.
• GWLB encapsulates the original IP traffic with a GENEVE header and forwards it to the network
appliance over UDP port 6081.
• GWLB uses 5-tuples or 3-tuples of an IP packet to pick an appliance for the life of that flow. This
creates session stickiness to an appliance for the life of a flow required for stateful appliances like
firewalls.
• This combined with Transit Gateway Appliance mode, provides session stickiness irrespective of
source and destination AZ.

centralized vpc interface endo`points

![[Pasted image 20240809173904.png]]so basically here we are reducing the redundant task of creating the vpc endpoints and provate link foreach vpc and just adding a transit gatewya so all the vpcs can access those vpc endpoint usning a single vpc and inter vpc access is blocked
more efficienlty we can use vpc peering with that vpc to other if we dont want intervpc access and we have less than 125 vpcs
![[Pasted image 20240809174411.png]]

also we need to disable provate dns endpoints for the vpc endpoints and create a private hosted zone and attach it to the other vpcs so they cna resolve the ip adress of the vpc endpoints since there will be no dns server aceess in a provate subnet just like in the below image

![[Pasted image 20240809174302.png]]
• VPC interface endpoints provides the regional and AZ level DNS endpoints
• The regional DNS endpoint will return the IP addresses for all the AZ endpoints
• In order to save the inter-AZ data transfer cost from Spoke VPC to Hub VPC, you can use the AZ
specific DNS endpoints. Selection has to be done by the client.