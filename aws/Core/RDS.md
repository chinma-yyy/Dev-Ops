# Relational Database Service (RDS)

AWS RDS is a service used for relational databases like MySQL, PostgreSQL, and others. AWS also offers its own high-performance database service called Aurora, which provides improved performance and scaling capabilities.

## Read Replicas

Read replicas are database instances used for read-only purposes. They help distribute the load and prevent bottlenecks on the primary database instance. Key points about read replicas:

- Up to 15 read replicas can be created.
- Replicas can be within the same Availability Zone (AZ), across different AZs, or even across regions.
- Replication between the master and read replicas is asynchronous, meaning that the data is eventually consistent.
- Read replicas can be promoted to become standalone databases.
- Applications must update their connection strings to use the read replicas.
- There is no network cost for data transfer between read replicas within the same region.

## Security

RDS and Aurora offer several security features:

- **At-Rest Encryption**: Data is encrypted using AWS Key Management Service (KMS). This must be defined at the time of launch. If the master database is not encrypted, the read replicas cannot be encrypted either. To encrypt an unencrypted database, you need to create a DB snapshot and restore it as an encrypted database.
- **In-Flight Encryption**: Databases are TLS-ready by default, using AWS TLS root certificates client-side.
- **IAM Authentication**: Allows using IAM roles to connect to the database instead of traditional username/password methods.
- **Security Groups**: Control network access to the RDS/Aurora database.
- **Audit Logs**: Can be enabled and sent to CloudWatch Logs for extended retention.
- **No SSH Access**: Except on RDS Custom, SSH access is not available.

## Amazon RDS Proxy

RDS Proxy is a fully managed database proxy service for RDS. It improves database efficiency and reduces stress on database resources. It basically keeps live connection already and on that same connection manages the pooling of new instances. Key features include:

- Pools and shares database connections to reduce the load on the database.
- Serverless, autoscaling, and highly available (multi-AZ).
- Reduces RDS and Aurora failover time by up to 66%.
- Supports RDS (MySQL, PostgreSQL, MariaDB, MS SQL Server) and Aurora (MySQL, PostgreSQL).
- No code changes required for most applications.
- Enforces IAM authentication for the database and securely stores credentials in AWS Secrets Manager.
- RDS Proxy is never publicly accessible and must be accessed from within a VPC.

## Amazon ElastiCache

ElastiCache is a service for managing in-memory databases like Redis or Memcached. It provides high performance and low latency, similar to how RDS manages relational databases.

## RDS – Storage Auto Scaling

-  Helps you increase storage on your RDS DB instance
dynamically
- When RDS detects you are running out of free database
storage, it scales automatically
-  You have to set Maximum Storage Threshold (maximum
limit for DB storage)
-  Automatically modify storage if:
-  Free storage is less than 10% of allocated storage
-  Low-storage lasts at least 5 minutes
-  6 hours have passed since last modification