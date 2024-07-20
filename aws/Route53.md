# Route 53

## DNS (Domain Name System)

The Domain Name System (DNS) translates human-friendly hostnames into machine IP addresses. For example, `www.google.com` is translated to `172.217.18.36`. DNS is a crucial part of the internet infrastructure and uses a hierarchical naming structure.

- **Domain Registrar**: Services like Amazon Route 53 and GoDaddy where you can register domain names.
- **DNS Records**: Various types like A, AAAA, CNAME, NS, etc.
- **Zone File**: Contains the DNS records.
- **Name Server**: Resolves DNS queries, either Authoritative or Non-Authoritative.
- **Top-Level Domain (TLD)**: Examples include .com, .us, .in, .gov, .org, etc.
- **Second-Level Domain (SLD)**: Examples include amazon.com, google.com, etc.

![[Pasted image 20240715131127.png]]

![[Pasted image 20240715131154.png]]
## **The image showing Root DNS server owned by ICANN and TLD DNS server owned by IANA is wrong info.**
## How DNS Works

### Step-by-Step Process

1. **DNS Query**:
   - A user enters a domain name (e.g., www.example.com) into their web browser.

2. **Recursive Resolver**:
   - The browser sends a query to a recursive resolver, a type of DNS server that can query other DNS servers on behalf of the user.

3. **Root Name Server**:
   - The recursive resolver queries a root name server. Root name servers are responsible for directing queries to the appropriate top-level domain (TLD) name servers (e.g., .com, .net).

4. **TLD Name Server**:
   - The recursive resolver then queries the TLD name server. TLD name servers are responsible for providing information about the authoritative name servers for the specific domain.

5. **Authoritative Name Server**:
   - Finally, the recursive resolver queries the authoritative name server for the domain. The authoritative name server holds the DNS records for the domain and provides the IP address associated with the domain name.

6. **Response**:
   - The IP address is returned to the browser. The browser can then contact the web server using the provided IP address and load the website.
### Example

- **User Action**: User types "www.example.com" in the browser.
- **Browser**: Sends a DNS query to the recursive resolver.
- **Recursive Resolver**: Queries a root name server.
- **Root Name Server**: Responds with the address of the .com TLD name server.
- **Recursive Resolver**: Queries the .com TLD name server.
- **TLD Name Server**: Responds with the address of the authoritative name server for "example.com".
- **Recursive Resolver**: Queries the authoritative name server.
- **Authoritative Name Server**: Responds with the IP address for "www.example.com".
- **Recursive Resolver**: Returns the IP address to the browser.
- **Browser**: Contacts the web server at the provided IP address and loads the website..
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


## CNAME vs Alias

### CNAME:
- Points a hostname to any other hostname. (e.g., `app.mydomain.com` => `blabla.anything.com`)
- **ONLY FOR NON ROOT DOMAIN** (e.g., `something.mydomain.com`)

### Alias:
- Points a hostname to an AWS Resource (e.g., `app.mydomain.com` => `blabla.amazonaws.com`)
- Works for **ROOT DOMAIN** and **NON ROOT DOMAIN** (e.g., `mydomain.com`)
- Free of charge

## Alias Records
- Maps a hostname to an AWS resource
- An extension to DNS functionality
- Automatically recognizes changes in the resource’s IP addresses
- Unlike CNAME, it can be used for the top node
- Alias Record is always of type A/AAAA for AWS resources (IPv4 / IPv6)
- You can’t set the TTL
- **You cannot set an ALIAS record for an EC2 DNS name**

# Routing Policies

## Simple
- Typically, route traffic to a single resource
- Can specify multiple values in the same record
- If multiple values are returned, a random one is chosen by the client
- When Alias enabled, specify only one AWS resource
- Can’t be associated with Health Checks

## Weighted
- Control the percentage of requests that go to each specific resource
- Assign each record a relative weight:
  - Weights don’t need to sum up to 100
  - DNS records must have the same name and type
  - Can be associated with Health Checks
- Use cases: load balancing between regions, testing new application versions
- Assign a weight of 0 to a record to stop sending traffic to a resource
- If all records have a weight of 0, then all records will be returned equally

## Latency
- Redirect to the resource that has the least latency close to us
- Super helpful when latency for users is a priority
- Latency is based on traffic between users and AWS Regions
  - Germany users may be directed to the US if that’s the lowest latency
- Can be associated with Health Checks (has a failover capability)

## Failover (Active-Passive)
- Create health checks for monitoring
  - Health Checks pass only when the endpoint responds with 2xx and 3xx status codes
  - Health Checks can be set up to pass/fail based on the text in the first 5120 bytes of the response
  - Configure your router/firewall to allow incoming requests from Route 53 Health Checkers
  - Health Checks are integrated with CloudWatch metrics
  - About 15 global health checkers will check the endpoint health
  - Healthy/Unhealthy Threshold: 3 (default)
  - Interval: 30 sec (can set to 10 sec – higher cost)
  - Supported protocol: HTTP, HTTPS, and TCP
  - If > 18% of health checkers report the endpoint is healthy, Route 53 considers it Healthy. Otherwise, it’s Unhealthy
  - Combine the results of multiple Health Checks into a single Health Check
    - You can use OR, AND, or NOT
    - Can monitor up to 256 Child Health Checks
    - Specify how many of the health checks need to pass to make the parent pass
  - Usage: perform maintenance on your website without causing all health checks to fail

## Geolocation
- Different from Latency-based!
- This routing is based on user location
- Specify location by Continent, Country, or by US State
  - If there’s overlapping, the most precise location is selected
- Should create a “Default” record in case there’s no match on location
- Use cases: website localization, restrict content distribution, load balancing
- Can be associated with Health Checks

## Geoproximity
Must use the traffic flow for creating these policies
- Route traffic to your resources based on the geographic location of users and resources
- Ability to shift more traffic to resources based on the defined bias
  - To change the size of the geographic region, specify bias values:
    - To expand (1 to 99) – more traffic to the resource
    - To shrink (-1 to -99) – less traffic to the resource

## IP-based Routing
- Routing is based on clients’ IP addresses
- You provide a list of CIDRs for your clients and the corresponding endpoints/locations (user-IP-to-endpoint mappings)

## Multi-Value
- Use when routing traffic to multiple resources
- Route 53 returns multiple values/resources
- Can be associated with Health Checks (return only values for healthy resources)
- Up to 8 healthy records are returned for each Multi-Value query
- Multi-Value is not a substitute for having an ELB

## Using Route 53 with a Third-Party Registrar
- If you buy your domain on a third-party registrar, you can still use Route 53 as the DNS Service provider:
  1. Create a Hosted Zone in Route 53
  2. Update NS Records on the third-party website to use Route 53 Name Servers