# AWS VPC Overview

## Virtual Private Cloud (VPC)
- Launch AWS resources into a virtual network that you've defined.
- VPC closely resembles a traditional on-premises network.
  
### AWS Regions and Availability Zones (AZs)
- AWS regions are geographical areas with multiple, isolated locations known as Availability Zones (AZs).
- AZs are data centers within a region, and a collection of AZs forms a region.
  
### Default VPC
- AWS creates a default VPC in each AWS region.
- The default VPC is created with a CIDR block of `172.31.0.0/16`.
- Subnets are created in every AZ within the region with a CIDR block of `/20`.
- An Internet Gateway is automatically created.
- A main route table is provided, with a route to the Internet, making all subnets public.
- If deleted, you can recreate the default VPC.

## CIDR – Classless Inter-Domain Routing
- CIDR is an IP addressing scheme that replaces the old address style of Class A, B, C.
- It is represented as an IP address followed by a prefix.
- Example: IPv4 CIDR `192.168.0.0/16`.
  - Starting address: `192.168.0.0`
  - Address range: `192.168.0.0` – `192.168.255.255` (65,536 IP addresses).

### CIDR Examples
- `192.168.0.0/24`: `192.168.0.0` – `192.168.0.255` (256 IP addresses).
- `192.168.0.0/16`: `192.168.0.0` – `192.168.255.255` (65,536 IP addresses).
- `134.56.78.123/32`: Just `134.56.78.123` (1 IP address).
- `0.0.0.0/0`: All IP addresses.

## AWS VPC CIDR (IPv4)
- VPC CIDR blocks can range between `/16` (65,536 IPs) and `/28` (16 IPs).
- **RFC 1918** IP ranges for private networks and corresponding AWS-recommended ranges:
  - `10.0.0.0/8` => `10.0.0.0` – `10.255.255.255`
  - `172.16.0.0/12` => `172.16.0.0` – `172.31.255.255`
  - `192.168.0.0/16` => `192.168.0.0` – `192.168.255.255`
- Subnet CIDR prefixes must be between `/16` and `/28` (same as VPC CIDR).

### AWS VPC CIDR (IPv6)
- VPC CIDR with a prefix of `/56` (2^72 IPs).
- IPv6 CIDR is allocated by AWS.
- Subnet CIDR prefix is `/64`.
- IPv6 addresses are globally unique and publicly routable.

## Subnets
- Subnets are a range of IP addresses in your VPC.
- They allocate a portion of the VPC's CIDR block for use by AWS resources.
- Types of subnets:
  - **Public Subnet**:
    - CIDR block example: `172.31.0.0/16`.
    - Has a route to the Internet.
    - Instances with public IPs can communicate with the Internet.
    - Example uses: NAT, Web servers, Load balancers.
  - **Private Subnet**:
    - No direct route to the Internet.
    - Instances receive private IPs.
    - Typically uses NAT for instances to access the Internet.
    - Example uses: Database servers, App servers.

### Reserved IP Addresses
- AWS reserves 5 IP addresses (first 4 and last 1) in each subnet.
- These 5 IP addresses are not available for use:
  - `10.0.0.0`: Network address.
  - `10.0.0.1`: Reserved by AWS for the VPC router.
  - `10.0.0.2`: Reserved by AWS for mapping to Amazon-provided DNS.
  - `10.0.0.3`: Reserved by AWS for future use.
  - `10.0.0.255`: Network broadcast address (not supported in a VPC).

## Route Table
- Contains rules to route traffic in/out of subnets/VPC.
- Main route table exists at the VPC level.
- Custom route tables can be created at the subnet level.
- Each route table contains a default, immutable local route for the VPC.
- If no custom route table is defined, new subnets are associated with the main route table.
- The main route table can be modified.

## Internet Gateway (IGW)
- A gateway that enables your VPC to connect to the Internet.

## Firewalls Inside VPC
### Security Groups
- Regulate:
  - Access to ports.
  - Authorized IP ranges – IPv4 and IPv6.
  - Control inbound network (from others to the instance).
  - Control outbound network (from the instance to others).
- Security groups are stateful, meaning any inbound rule automatically allows the corresponding outbound traffic, and vice versa.
- You can reference another security group as a source.

### Network Access Control List (NACL)
- Operates at the subnet level – hence automatically applied to all instances in the subnet.
- Stateless – inbound and outbound rules must be explicitly defined.
- Contains both allow and deny rules.
- Rules are evaluated in order based on the rule number.
- Default NACL allows all inbound and outbound traffic.
- NACLs are effective for blocking specific IP addresses at the subnet level.

## NAT Gateway
- Provides Internet access to instances in a private subnet without an IGW.
- Performs Network Address Translation (NAT) when packets leave the VPC.
- There is no cross-AZ failover, as if an AZ goes down, NAT is not needed.
- Managed by AWS and highly available within the AZ.

### NAT Instance
- Must be in a public subnet.
- Must have a public or elastic IP.
- Should be launched using AWS-provided NAT AMIs.
- Disable source/destination check.
- Update private subnet route tables – for Internet traffic, set the target as the NAT Instance ID.

## VPC Secondary CIDR Blocks
1. You can add secondary VPC CIDRs to an existing VPC.
2. The CIDR block must not overlap with existing CIDRs or peered VPC CIDRs.
3. If the primary CIDR is from **RFC 1918**, then you cannot add secondary CIDRs from other RFC 1918 IP ranges (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`).
4. The CIDR block must not be the same or larger than the CIDR range of routes in any of the VPC route tables.
   - Example: If the VPC primary CIDR block is `10.0.0.0/16` and you want to associate a secondary CIDR block in the `10.2.0.0/16` range, but you already have a route with a destination of `10.2.0.0/24` to a virtual private gateway, you cannot associate a CIDR block of the same range or larger. However, you can associate a CIDR block of `10.2.0.0/25` or smaller.
5. You can have a total of 5 IPv4 and 1 IPv6 CIDR blocks for a VPC.
6. You can also add CIDR ranges of `100.64.0.0/16` for secondary CIDR blocks.
