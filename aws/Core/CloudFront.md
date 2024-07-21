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

## Additional Features

### Edge Functions
- **Lambda@Edge**: Run Lambda functions at CloudFront edge locations to customize content delivery. For example, use Lambda@Edge to modify headers, perform URL redirects, or generate dynamic content.

### Monitoring and Logging
- **Access Logs**: Enable logging to capture detailed information about every user request. These logs are stored in an S3 bucket.
- **Metrics and Alarms**: Use CloudWatch to monitor CloudFront performance metrics and set alarms for specific thresholds.

### Geolocation Restrictions
Restrict content delivery based on the geographic location of viewers.