# AWS DynamoDB 

## Overview
Amazon DynamoDB is a fully managed NoSQL database service that provides fast and predictable performance with seamless scalability. DynamoDB allows developers to offload the administrative burdens of operating and scaling distributed databases, so they don't have to worry about hardware provisioning, setup and configuration, replication, software patching, or cluster scaling.

## Key Concepts

### Tables
- **Table**: A collection of data items in DynamoDB. Each table is uniquely identified by its name.
- **Items**: Each table contains multiple items. An item is a collection of attributes.
- **Attributes**: Attributes are the fundamental data elements of an item.

### Primary Keys
- **Partition Key**: A simple primary key, composed of one attribute known as the partition key.
- **Composite Primary Key**: This consists of two attributes, the partition key and the sort key. It allows for more complex queries.

### Secondary Indexes
- **Global Secondary Index (GSI)**: Allows queries on non-primary key attributes across the entire table.
- **Local Secondary Index (LSI)**: Allows queries on non-primary key attributes within the context of a partition key.

### Data Types
- **Scalar Types**: String, Number, Binary, Boolean, Null.
- **Document Types**: List, Map.
- **Set Types**: String Set, Number Set, Binary Set.

## Read and Write Operations

### Reading Data
- **GetItem**: Retrieve a single item by its primary key.
- **BatchGetItem**: Retrieve multiple items by their primary keys in a single request.
- **Query**: Retrieve multiple items that have the same partition key value.
- **Scan**: Retrieve all items in a table or a secondary index.

### Writing Data
- **PutItem**: Create a new item or replace an existing item.
- **BatchWriteItem**: Perform multiple PutItem and DeleteItem operations in a single request.
- **UpdateItem**: Modify an existing item's attributes.
- **DeleteItem**: Remove an item by its primary key.

## Advanced Features

### Conditional Writes
Ensure that an item is only written if it meets certain conditions.

### Atomic Counters
Increment or decrement a numeric attribute without interfering with other write requests.

### Transactions
- **TransactWriteItems**: A coordinated, all-or-nothing batch operation that can include Put, Update, and Delete operations on multiple items across multiple tables.
- **TransactGetItems**: A batch operation that retrieves multiple items from one or more tables.

### Streams
Capture a time-ordered sequence of item-level changes in a DynamoDB table. Enable real-time processing of table updates (e.g., triggering Lambda functions).

### Time to Live (TTL)
- **TTL**: Automatically delete items after a specified timestamp. Useful for removing expired data to reduce storage costs.

### DynamoDB Accelerator (DAX)
- **DAX**: An in-memory cache for DynamoDB that provides fast, local, read performance. DAX reduces the response times from milliseconds to microseconds, even under high request loads.

## Scalability and Performance

### Provisioned Throughput
- **Read Capacity Units (RCUs)**: One RCU represents one strongly consistent read per second for items up to 4 KB in size.
- **Write Capacity Units (WCUs)**: One WCU represents one write per second for items up to 1 KB in size.

### On-Demand Capacity Mode
Automatically scales to handle sudden increases in traffic without the need for capacity planning.

### Adaptive Capacity
Automatically adjusts provisioned throughput to handle uneven data access patterns.

### Global Tables
Multi-region, fully replicated tables that provide fast, local read and write performance for globally distributed applications.

### Partitioning Strategies
- **Uniform Distribution**: Ensure that your partition key values are evenly distributed to avoid "hot" partitions.
- **Shard Splitting**: Dynamically split partitions to distribute data more evenly.
- **Composite Keys**: Use a composite key to distribute write operations more evenly across partitions.

## Security

### Encryption
- **At Rest**: Data is automatically encrypted at rest using AWS Key Management Service (KMS).
- **In Transit**: Data is encrypted in transit using TLS.

### Access Control
- **IAM Policies**: Control access to DynamoDB tables and indexes at the API level.
- **Fine-Grained Access Control**: Restrict access to individual items and attributes.

### VPC Endpoints
Securely connect to DynamoDB without needing an internet gateway, NAT device, VPN connection, or AWS Direct Connect connection.

## Backup and Restore
- **On-Demand Backup**: Create full backups of DynamoDB tables.
- **Point-in-Time Recovery (PITR)**: Restore a table to any point in time from the past 35 days.

## Monitoring and Logging

### CloudWatch Metrics
Monitor capacity usage, request rates, error rates, and latency.

### CloudWatch Alarms
Set alarms to alert you when your usage exceeds thresholds that you define.

### AWS CloudTrail
Log API calls made to DynamoDB for auditing.

### DynamoDB Streams
Use streams to capture table activity and integrate with other AWS services like Lambda.

## Best Practices

### Data Modeling
- Design tables and indexes to support your application's query patterns.
- Use composite keys and secondary indexes to optimize query performance.

### Capacity Management
- Choose between provisioned and on-demand capacity modes based on your application's traffic patterns.
- Monitor capacity usage and set appropriate alarms.

### Security
- Use IAM policies and fine-grained access control to restrict access.
- Encrypt sensitive data both at rest and in transit.

### Backup and Restore
- Regularly backup your tables and enable point-in-time recovery.
- Test your restore procedures to ensure they meet your recovery objectives.

### Monitoring
- Continuously monitor your tables using CloudWatch metrics and alarms.
- Use CloudTrail to log and audit API calls.
