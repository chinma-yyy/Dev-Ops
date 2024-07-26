# AWS Lambda 

## Overview
AWS Lambda is a serverless computing service that allows developers to deploy code without managing the underlying servers. This serverless paradigm means developers only need to focus on their code, while AWS handles the provisioning, scaling, and maintenance of the infrastructure.

## Invocation Types

### Synchronous Invocation
- The client waits for a response from the Lambda function.
- Examples:
  - **Lambda with Application Load Balancer (ALB)**:
    - Expose a Lambda function as an HTTP(S) endpoint.
    - Lambda function must be registered in a target group.
    - ALB converts the request into JSON accessible in the event object.
    - Enable multi-header options for headers or query strings with multiple values.
    - Return the response as JSON, which is translated by the ALB.

### Asynchronous Invocation
- The client does not wait for a response. The function is executed, and it may be retried upon failure based on the policy.
- Examples:
  - **Lambda with S3 Create Object Event**:
    - Events are placed in an event queue.
    - Lambda attempts retries on errors (up to 3 tries).
    - Wait times: 1 minute after the 1st try, then 2 minutes after the 2nd try.
    - Ensure idempotent processing to handle retries.
    - Duplicate log entries may appear in CloudWatch Logs.
    - Define a Dead Letter Queue (DLQ) for failed processing (using SNS or SQS with correct IAM permissions).

## Event Source Mapping
- Used when events need to be polled from the source.

### SQS & SQS FIFO
- Add a trigger to the Lambda function to create this poll.
- Poll SQS using Event Source Mapping (long polling).
- Specify batch size (1-10 messages).
- Recommended queue visibility timeout: 6x the Lambda function timeout.
- Use DLQ on the SQS queue (not on Lambda, as DLQ for Lambda is only for async invocations).
- Alternatively, use a Lambda destination for failures.

### Streams & Lambda (Kinesis & DynamoDB)
- Event source mapping creates an iterator for each shard and processes items in order.
- Start processing from new items, the beginning, or a specific timestamp.
- Processed items are not removed from the stream (other consumers can read them).

## Lambda Event Mapper Scaling
- **Kinesis Data Streams & DynamoDB Streams**:
  - One Lambda invocation per stream shard.
  - Up to 10 batches processed per shard simultaneously with parallelization.
- **SQS Standard**:
  - Lambda adds 60 more instances per minute to scale up.
  - Up to 1000 batches of messages processed simultaneously.
- **SQS FIFO**:
  - Messages with the same GroupID are processed in order.
  - Lambda function scales to the number of active message groups.

## Event Object and Context Object
- **Event Object**:
  - JSON-formatted document with data for the function to process.
  - Contains information from the invoking service (e.g., EventBridge, custom).
  - Lambda runtime converts the event to an object (e.g., dict type in Python).

- **Context Object**:
  - Provides methods and properties with information about the invocation, function, and runtime environment.
  - Examples: `aws_request_id`, `function_name`, `memory_limit_in_mb`.

## Lambda Destinations
- Destinations for Lambda responses can be configured based on the success or failure of asynchronous invocations.
- Set up success or failure destinations (e.g., SQS queue) to monitor Lambda invocations.

## Environment Variables
- Environment variables can be set from the configuration or the KMS.
- Some environment variables are directly embedded into the function.

## CloudWatch Integration
- **CloudWatch Logs**:
  - AWS Lambda execution logs are stored in CloudWatch Logs.
  - Requires a policy that authorizes writes to CloudWatch Logs.

- **CloudWatch Metrics**:
  - AWS Lambda metrics are displayed in CloudWatch Metrics.
  - Metrics include invocations, durations, concurrent executions, error count, success rates, throttles, async delivery failures, iterator age (for Kinesis & DynamoDB Streams).

## AWS X-Ray Integration
- Enable active tracing in Lambda configuration to run the X-Ray daemon.
- Use the AWS X-Ray SDK in code.
- Communicate with X-Ray using environment variables (`_X_AMZN_TRACE_ID`, `AWS_XRAY_CONTEXT_MISSING`, `AWS_XRAY_DAEMON_ADDRESS`).

## VPC Integration
- By default, Lambda functions run outside the user's VPC.
- To access VPC resources, define the VPC ID, subnets, and security groups.
- Lambda creates an ENI (Elastic Network Interface) in the specified subnets.
- Deploying a Lambda function in a public subnet does not provide internet access or a public IP.
- Deploying a Lambda function in a private subnet requires a NAT Gateway/Instance for internet access.

## Resource Configuration
- **RAM**:
  - From 128MB to 10GB in 1MB increments.
  - More RAM provides more vCPU credits (up to 6 vCPU).
  - If the application is CPU-bound, increase RAM.
- **Timeout**:
  - Default: 3 seconds, maximum: 900 seconds (15 minutes).

## Execution Context
- The execution context is a temporary runtime environment that initializes external dependencies of the Lambda code (e.g., database connections, HTTP clients, SDK clients).
- The execution context is maintained for a while to anticipate another Lambda function invocation, allowing context reuse.
- The execution context includes the `/tmp` directory.

## Temporary Storage
- The `/tmp` directory provides up to 10GB of disk space for temporary operations.
- Directory content remains when the execution context is frozen, providing transient cache for multiple invocations.

## Lambda Layers
- Lambda layers contain compiled code or dependencies that do not change frequently.
- Layers can be referenced by functions and are used to provide runtimes for non-supported languages by AWS.

## Concurrency and Throttling

### Concurrency Limit
- The concurrency limit is the total number of Lambda function executions allowed simultaneously across the entire account, currently set at 1000.
- **Reserved Concurrency**:
  - Sets a limit for a single function's concurrency.
  - If the limit is reached:
    - Synchronous invocations return a 429 status code.
    - Asynchronous invocations retry automatically, and the event goes to DLQ.

### Provisioned Concurrency
- Concurrency is allocated before the function is invoked, preventing cold starts and ensuring low latency.
- Managed by Application Auto Scaling (schedule or target utilization).

## Lambda Function Dependencies
- Upload the zip file directly to Lambda if less than 50MB, otherwise upload to S3 first.
- Native libraries need to be compiled on Amazon Linux.
- AWS SDK is included by default with every Lambda function.

## Lambda Container Images
- Deploy Lambda functions as container images (up to 10GB) from ECR.
- Useful for packaging complex or large dependencies.
- Base images available for Python, Node.js, Java, .NET, Go, Ruby.
- Custom images can be created as long as they implement the Lambda Runtime API.

## Lambda Versions and Aliases

### Versions
- Lambda function code and configuration can be published as versions.
- Versions are immutable and have unique ARNs.
- Versions enable access to specific iterations of Lambda functions.

### Aliases
- Aliases are pointers to Lambda function versions.
- Used to manage environments (e.g., dev, test, prod) by pointing to different versions.
- Aliases are mutable and enable canary deployments by assigning weights to Lambda functions.
- Aliases have unique ARNs but cannot reference other aliases.

## Dedicated HTTP(S) Endpoint for Lambda
- A unique URL endpoint is generated for each Lambda function (never changes).
  - Format: `https://<url-id>.lambda-url.<region>.on.aws` (dual-stack IPv4 & IPv6).
- Invoke via a web browser, curl, Postman, or any HTTP client.
- Supports resource-based policies and CORS configurations.
- Can be applied to any function alias or `$LATEST`, but not to other function versions.
