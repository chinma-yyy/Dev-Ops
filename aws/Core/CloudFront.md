# CloudFront 

CloudFront is a CDN service that caches data at edge locations, which are AWS data centers set up for this purpose. Multiple components are involved in configuring CloudFront.

## Key Components

### Origin
The origin is the main service that provides the data to be cached. The origin domain is the address or domain attached to it through which we can access the origin, typically our web servers. CloudFront can have multiple origins to provide different data and routing policies. Origin groups enable failover; if one origin in the group fails, the other takes over.

### Cache Policy
Cache policies define when and how long to cache data, along with other caching behaviors. A cache key is used to specify the fields (e.g., headers, query strings) based on which data is cached. Only fields defined in the cache policy are forwarded; other headers or fields like authentication or session details require an origin access policy.

### Origin Access Policy (OAC)
An origin access policy defines which fields are required by the origin and should be forwarded. If fields are not mentioned in the OAC or cache policy, they are not forwarded.

### Cache Invalidation Policies
These policies specify when to remove data from the cache or refresh it, and are defined based on the URL path.

### CloudFront Signed URL
Using a private key and public key, you can create a signed URL for user access to CloudFront data. The SDK generates the URL, and keys must be uploaded or created and used in the key group options.

we can add custom headers in the cloudfront which we can use to verify whether the request came from the cloudfront or not and can be handled accordingly based on the condition.

while attaching any certificate to the cloudfront it needs to be created or uploaded to the acm and it should be created in us east n viginia region even if it is a global service

## Additional Features

## Edge Functions

### Lambda@Edge
- **Lambda@Edge**: Run Lambda functions at CloudFront edge locations to customize content delivery. Examples of use cases include generating dynamic content.

### CloudFront Functions
- **CloudFront Functions**: Run lightweight JavaScript functions at CloudFront edge locations. These functions are highly scalable and can be used to inspect or modify HTTP request and response headers. Examples of use cases include:
  - **Header manipulation**: Insert, modify, or delete HTTP headers in the request or response.
  - **URL rewrites or redirects**: Modify URLs to direct traffic as needed.
  - **Request authentication & authorization**: Create and validate user-generated tokens (e.g., JWT) to allow or deny requests.
![[Pasted image 20240725220127.png]]
### Monitoring and Logging
- **Access Logs**: Enable logging to capture detailed information about every user request. These logs are stored in an S3 bucket.
- **Metrics and Alarms**: Use CloudWatch to monitor CloudFront performance metrics and set alarms for specific thresholds.

### Geolocation Restrictions
Restrict content delivery based on the geographic location of viewers.

aws global accelorator 
it is not a service from cloudfront but works from the edge locations of aws
so basically it uses anycast ip which is multiple servers have same ip address and the request if forwarded to the closest server
in this case the requset is forwarded to the closest edge location and then with the aws network it reaches the origin here also it reduces the latency as it used aws network and reduces the hops in the request
both use aws shield and help provide safety from ddos attacks