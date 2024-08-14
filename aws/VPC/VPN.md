Autonomous systems 
it is a collection of instances in the network . they have numbers which are asn and are assigned by iana for public asn and we have private asn range from 64512 - 65534

static routing
so in the routers we just add the static cidr range of the adresss for the destination and we can reach the destiination but we need to everytime add the route for each location and we cannot figure out any transitive routes instead we have to explicitly add the route to the transitive route using any method we prefer.

dynamic routing
in dynamic routing the routes are propogateed automatically like the first vpc can go through the secodn vpc to the third vpc and we need not add the address of the routers to hop explicitly
• Dynamic Routing using Path-Vector protocol where it exchanges the
best path to a destination between peers or AS (ASPATH)
• iBGP – Routing within AS
• eBGP – Routing between AS’s
• Routing decision is influenced by
• Weight (Cisco routers specific – works within AS)
• ASPATH – Series of AS’s to traverse the path (Works between AS)
like go from 1 to 2 and 2 to 3 to reach 3 and also 1 to 4 and 4 to 3 to reach 3
• Local Preference LOCAL_PREF (Works within AS)
this is the preference of routers in the inter as which is defined
• MED – Multi-Exit Discriminator (Works between AS)
and if the aspath and local pref is same then med is the discriminating factor 

with this we can choose the route which is currently active and in case of failover of one route we can use another path using as path
and also get the most badwidth 

• VPN allows hosts to communicate privately over an untrusted
intermediary network like internet, in encrypted form
• AWS supports Layer 3 VPN (not Layer 2)
• VPN has 2 forms – Site to Site VPN and Client to Site VPN
• Site to Site VPN connects 2 different networks.
• Client to Site VPN connects the client device like laptop to the private network
• VPN types
• IPSec (IP Security) VPN which is supported by AWS managed VPN
• Other VPNs like GRE and DMVPN are not supported by AWS managed VPN.

virtual private gateway
• Managed gateway endpoint for the VPC
• Only one VGW can be attached to VPC at a time
• VGW supports both Static Routing and Dynamic routing using Border
gateway protocol (BGP)
• For BGP, you can assign the private ASN (Autonomous System
Number) to VGW in the range of 64512 to 65534
• If you don’t define ASN, AWS assigns default ASN. ASN cannot be
modified once assigned (default 64512)
![[Pasted image 20240810095640.png]]
how ipsecvpn works
• VPN connection terminated at Virtual Private Gateway (VGW) on AWS end
• VGW creates 2 Tunnel endpoints in different AZs for High Availability

there are two phases in this connection 
the ike version is chosen and the phase starts
the ike internet key exchange phase 1 where the key is provided and they communicate over to come on a decision to the key value pair or the settings for encryption decryption.
once on the connection we have keep alive which keeps the connection between the entities alive or the dead peer connection which sends a packet in intervals and if a response is not recieved a specific action is carried out then 
then we decide on the auth type and encryption of data 
sa life is the lifetime of the tunnel and once it expires a new tunnel is created for the connection
then we have the dh group config the more the dh group the more the secure 

similarly for phase 2 we can see in the image similar steps happen and we have a secure connection between two asns

![[Pasted image 20240813111824.png]]

in this we will configure a site to site vpn connection but we will simulate the customer network here and use the aws vpc only as a customer premises

so we need to first configure the customer gateway which is the instance taking in the trafffic from our aws 
we need to install a vpn software like openswan and then configure it for the traffic forwarding 
also we need to configure for the sescurity group and vpc level firewalss to have traffic from the aws 
we also need to allow the udp port 500 for the connection since openswan uses that port for the customer side
then we need to create a virtual private gateway in the aws vpc and attach it with the vpc 
once attached we need to have a site to site vpn connection and in that we enter the details regarding the connection
we need to create a customer gateway or use an existing one where we enter the ip adress of the openswan instacne which is public since this is static we need to enter the cidr block as prefix list 
then we need to enter local ipv4 network cidr and remote ipv4 network cidr so it says like all the traffic for the cidr range inside the vpc should be from vpgw in the local cidr and for the remote cidr range traffic it should use customer gateway and rest as default 
then we need to download the configurations as in the file and configure the openswan instance accordingly it has all the details regarding our connectoin 

this should start our one of the tunnel for the vpn connnection


so in the case where the on premises is not exposed to the internet then we need to configure the nat gateway but in this case the nat gateway changes the source ip when it recieves the packets but the hash will have the nat instance ip and on reaching the final instance it will discard the traffic as it was tampered this all is done using authentication headers so for this problem nat traversal was introduced 
so once we enable nat traversal it uses esp protocol which uses another udp 4500 port which communicates the udp headers over 4500 and other hashes iver the connection and we can have a secure connection

VPN Static and Dynamic routing
• In case of static routing, you must pre-define the CIDR ranges on both
sides of the VPN connection. If you add new network ranges on either
sides, the routing changes are not propagated automatically
• In case of Dynamic routing, both the ends learns the new network
changes automatically. On AWS side, the new routes are automatically
propagated in the route tables.
• AWS route table can not have more than 100 propagated routes.
Hence you need to make sure you don’t publish more than 100
routes from on-premises network
• To avoid this situation, you may think to consolidate network ranges into
larger CIDR range

• From on-premises to AWS via Virtual Private Gateway:
• You can not access Internet through VPC attached Internet Gateway
• You can not access Internet through NAT Gateway in Public subnet
• You can not access peered VPC resources through VPC peering connection via
the AWS VGW
• You can not access S3, DynamoDB via the VPC gateway endpoint
• You can access AWS services endpoint e.g API gateway, SQS and customer
endpoint services (powered by Privatelink) via VPC interface endpoint
• You can access Internet through NAT EC2 instance in Public subnet
• From AWS to on-premises via customer gateway
• You can access Internet and other network endpoints based on routing rules
setup on CGW in on-premises network


so in the tunnels we have two active active and active passive tunnels 
 in the case of the active active the returning traffic may return from different tunnel and the cgw will reject the traffic because of the state of the request this is known as assymetrci rotuing which we neeed to enable on the cgw and in case of the active passive the traffic flows from one tunnel only and if one tunnel goes down the other is brought up.


Dead Peer Detection (DPD) is a method to detect liveliness of IPSec VPN connection
VPN peers can decide during “IKE Phase 1” if they want to use DPD
If DPD is enabled AWS continuously (every 10 sec) sends DPD (R-U-THERE) message to customer
gateway and waits for the R-U-THERE-ACK. If there is no response to consecutive 3 requests, then
DPD times out.
• By default, when DPD occurs, the gateways delete the security associations.
During this process, the alternate IPsec tunnel is used if possible.
• Default DPD timeout value is 30 sec which can be set higher than 30
seconds.
• DPD uses UDP 500 or UDP 4500 to send DPD messages
ec2 based vpn
here basically we configure the vpn on the ec2 instance and we get full control on the behavour and also the protocol or diffrent vpn types which we can use and also we can use this instance for transitivity if we want and also can be used in case of redundant cidr ranges which cna be translated in this instance.
• Vertical scaling:
• Increase instance size for increased performance
• Horizontal scaling
• You can have the architecture which provides horizontal scaling
• IPsec as a protocol doesn’t function through a Network Load Balancer
due to non-Transmission Control Protocol (TCP) (IPSec protocol 50)
it cannot be kept behind a load balancer 
also this ec2 based vpn can be used as a transit gateway for vpn connection and also traffic monitoring and inspection 
aws client to site vpn
![[Pasted image 20240814122938.png]]
 limitations
 Client CIDR ranges cannot overlap with the local CIDR of the VPC in which the associated subnet is
located
Client CIDR ranges cannot overlap with any routes manually added to the Client VPN endpoint's
route table
Client CIDR ranges must have a block size between /22 and /12
The client CIDR range cannot be changed after you create the Client VPN endpoint
You cannot associate multiple subnets from the same Availability Zone with a Client VPN endpoint
A Client VPN endpoint does not support subnet associations in a dedicated tenancy VPC
Client VPN supports IPv4 traffic only

worling 
first we need to have the client server certificates which we have to create and upload to acm for authentication we can use saml sso or ad for authentication which enables us for user and role based authentication 
then we need to configure one subnet which will be the target subenet for the vpn where all the traffic will end and then will be forwarded in the vpc accordingly we have to also create security groups and also modify the route tables for other subnets also
then we create a vpn client endpoint where we put the client cidr range which will be the ip given to the user and also the acm certs for authentication and the vpc details and the subnet which can be used as a target subnet
once created we need to also add the ingress rules for the users to connect to the endpoint and also the routes for the cidr ranges for the vpn connection.
then we can download the vpn config file and we connect to the vpc using any vpn software by uploading the config along with the key and cert whihc is required for authentication 


for the internet connectivity we can have a internet gateway in the vpc and we can forward the 0.0.0.0/0 cidr to the igw and also we can  enable the twin tunnel which only  forwards the vpc traffic here and other internet traffic over to the internet and not through the vpn connection



 