# Elastic Network Interfaces (ENI)

- A logical component in a VPC that represents a virtual network card.
- It is basically like a network adaptor and we can have multiple of these for a single instance or resource in AWS.
- ENIs are bound to a specific availability zone (AZ).
- The ENI can have the following attributes:
  - A primary private IPv4 address from the IPv4 address range of the VPC.
  - A primary IPv6 address from the IPv6 address range of your VPC.
  - One or more secondary private IPv4 addresses from the IPv4 address range of your VPC.
  - One Elastic IP address (IPv4) per private IPv4 address.
  - One public IPv4 address.
  - One or more IPv6 addresses.
  - One or more security groups.
  - A MAC address.
  - A source/destination check flag.

## Dual Home Instances

- We have 2 ENIs in public and private subnets, allowing communication via both.
- Use VPN for data analytics or other tasks and public subnet for HTTP or other services.
- The number of ENIs you can attach to an instance and the number of secondary IP addresses per ENI depends on the EC2 instance type.
- You associate security groups with network interfaces and not with individual IP addresses.
- ENIs cannot be used for NIC teaming, meaning they cannot be used together to increase instance network bandwidth.

## Requester Managed ENIs

- AWS hosts other services like RDS and EKS, which do not provide us the infrastructure but manage the ENI in their own VPC and provide us the managed ENIs to access the data.

## Using ENI Secondary IPs for EKS Pods

- We can use the multiple private IP addresses allocated to the ENIs for the pods in the cluster hosted in our EC2 instance.
- Based on the number of private IPs we have, we can have that many pods in the instance.

## Bring Your Own IP

- You can migrate your publicly routable IPv4 and IPv6 IP addresses to AWS.

### Why?

- Keep your IP address reputation.
- Avoid changes to IP address whitelisting.
- Move applications without changing the IP addresses.
- AWS as a hot standby.

## DNS and DHCP

- VPC comes with a default DNS server, also called the Route53 DNS Resolver.
- Runs at VPC Base + 2 Address (can also be accessed from within the VPC at virtual IP 169.254.169.253).
- VPC comes with a default DHCP Option set which provides these dynamic host configurations to the instances on launch.

### Default DHCP Sets

- Domain-name=ap-south-1.compute.internal;
- Name-servers=AmazonProvidedDNS.

- These DHCP option sets must be changed from the VPC, and these DHCP configurations set the domain name and nameserver configurations for our instances in VPC, and also the hostname.
- The details are found in the `/etc/resolv.conf` file where we have the nameserver and search, which is the domain name.

## DNS Resolution from Outside VPC

### Route53 Resolver Endpoint

- Officially named the .2 DNS resolver to Route 53 Resolver.
- Provides Inbound & Outbound Route53 resolver endpoints.
- Provisions ENI in the VPC which are accessible over VPN or DX.
- Inbound -> On-premise forwards DNS request to R53 Resolver.
- Outbound -> Conditional forwarders for AWS to On-premise.

## Network Optimizations

- **Bandwidth** – Maximum rate of transfer over the network.
- **Latency** – Delay between two points in a network.
  - Delays include propagation delays for signals to travel across the medium.
  - Also includes the processing delays by network devices.
- **Jitter** – Variation in inter-packet delays.
- **Throughput** – Rate of successful data transfer (measured in bits per sec).
  - Bandwidth, Latency, and Packet loss directly affect the throughput.
- **Packet Per Second (PPS)** – How many packets processed per second.
- **Maximum Transmission Unit (MTU)** – Largest packet that can be sent over the network.

### Jumbo Frames

- 9001 MTU.
- Jumbo frames are enabled in a VPC by default.
- AWS supports jumbo frames within VPC; however, traffic leaving VPC over IGW or inter-region VPC peering does not support jumbo frames (Limited to 1500 bytes).
- Jumbo frames are also supported between VPC and on-premises network using AWS Direct Connect.
- Using jumbo frames inside EC2 cluster placement groups provides maximum network throughput.
- Jumbo frames should be used with caution for traffic leaving the VPC. If packets are over 1500 bytes, they are fragmented, or they are dropped if the Don't Fragment flag is set in the IP header.

- MTU also depends on Instance Type.
- Defined at the ENI level.
- You can check the path MTU between your device and target endpoint using the `tracepath` command.
  - `tracepath amazon.com` does 30 requests.
- To check the MTU on your interface:
  - `ip link show eth0`
- To set MTU value on Linux:
  - `sudo ip link set dev eth0 mtu 9001`

### Within AWS:

- Within VPC: Supports Jumbo frames (9001 bytes).
- Over the VPC Endpoint: MTU 8500 bytes.
- Over the Internet Gateway: MTU 1500 bytes.
- Intra-region VPC Peering: MTU 9001 bytes.
- Inter-region VPC Peering: MTU 1500 bytes.

### On-premise Network:

- Over the VPN using VGW: MTU 1500 bytes.
- Over the VPN via Transit Gateway: MTU 1500 for traffic for Site to Site VPN.
- Over the DirectConnect (DX): Supports Jumbo frames (9001 bytes).
- Over the DX via Transit Gateway: MTU 8500 for VPC attachments connected over the Direct Connect.

