# Route 53

## DNS (Domain Name System)

The Domain Name System (DNS) translates human-friendly hostnames into machine IP addresses. For example, `www.google.com` is translated to `172.217.18.36`. DNS is a crucial part of the internet infrastructure and uses a hierarchical naming structure.

- **Domain Registrar**: Services like Amazon Route 53 and GoDaddy where you can register domain names.
- **DNS Records**: Various types like A, AAAA, CNAME, NS, etc.
- **Zone File**: Contains the DNS records.
- **Name Server**: Resolves DNS queries, either Authoritative or Non-Authoritative.
- **Top-Level Domain (TLD)**: Examples include .com, .us, .in, .gov, .org, etc.
- **Second-Level Domain (SLD)**: Examples include amazon.com, google.com, etc.
- 
![[Pasted image 20240715131127.png]]

![[Pasted image 20240715131154.png]]
## Record Types
- **A**: Maps a hostname to an IPv4 address.
- **AAAA**: Maps a hostname to an IPv6 address.
- **CNAME**: Maps a hostname to another hostname. The target must be a domain name that has an A or AAAA record. You cannot create a CNAME record for the top node of a DNS namespace (Zone Apex). For example, you cannot create a CNAME record for `example.com`, but you can create one for `www.example.com`.
- **NS**: Specifies the name servers for the hosted zone and controls how traffic is routed for a domain.

## Hosted Zone

A hosted zone is a container for records that define how to route traffic to a domain and its subdomains.

- **Public Hosted Zones**: Contain records that specify how to route traffic on the internet (public domain names), such as `application1.mypublicdomain.com`.
- **Private Hosted Zones**: Contain records that specify how to route traffic within one or more VPCs (private domain names), such as `application1.company.internal`.

**Cost**: You pay $0.50 per month per hosted zone.
