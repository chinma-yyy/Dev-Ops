# AWS Messaging Services 

## Amazon SQS (Simple Queue Service)

### Overview
Amazon SQS is a queue service that stores messages which can be up to 256 KB in size. Messages can be duplicated. The default retention period of messages is 4 days, with a maximum of 14 days. Messages produced by a producer stay in the queue until a consumer deletes them. Consumers can be EC2 instances, Lambda functions, and many other services.

### Message Visibility
Once a message is received by a consumer, it becomes invisible to other consumers. The consumer must process the message within the visibility timeout, or else the message will become visible in the queue again. A consumer can call the `ChangeMessageVisibility` API to extend the visibility timeout.

- **High visibility timeout**: If the consumer crashes, re-processing will take time.
- **Low visibility timeout**: There may be duplicates if processing isn't completed in time.

### Long Polling
When a consumer requests messages, it can wait up to 20 seconds to receive messages, reducing the number of API calls and lowering compute costs.

## FIFO Queue
- **Throughput**: 300 messages per second without batching, 3000 messages per second with batching.
- **Exactly-once send capability**: Removes duplicates.
- **Ordered Processing**: Messages are processed in order.
- **MessageGroupID**: Ensures messages are processed in order within the group and allows for parallel processing across different groups.

## Dead Letter Queue (DLQ)
- Messages return to the queue if not processed within the visibility timeout.
- Set a threshold for how many times a message can return to the queue.
- After the threshold is exceeded, the message goes into the DLQ.
- Useful for debugging.
- FIFO queues must have FIFO DLQs, and standard queues must have standard DLQs.
- Set a retention period of 14 days for DLQ messages.

## Delay Queue
- Delays messages up to 15 minutes.
- Default delay is 0 seconds (message is available immediately).
- Can set a default delay at the queue level or override it using the `DelaySeconds` parameter.

## AWS SNS (Simple Notification Service)

### Overview
AWS SNS follows a pub/sub model where the event producer sends messages to one SNS topic, and multiple event receivers (subscriptions) listen to the topic notifications.

### Fan Out
- Push once in SNS, receive in all SQS queues that are subscribers.
- Fully decoupled, no data loss.
- Allows for data persistence, delayed processing, and retries.
- Ability to add more SQS subscribers over time.

## Amazon Kinesis

### Overview
Kinesis involves producers and streams of messages, with shards configured to handle data intake. One shard supports up to 1 MB/s of data.

### Features
- **Retention**: 1 day to 365 days.
- **Reprocess (replay) data**: Ability to reprocess data.
- **Immutability**: Data cannot be deleted once inserted.

### Shard Management
- **Shard Splitting**: Increases stream capacity and divides hot shards. The old shard closes and will be deleted after data expiration. No automatic scaling; capacity changes are manual.
- **Merging Shards**: Decreases stream capacity and saves costs. Can group two cold shards. Old shards close and are deleted after data expiration.

## Kinesis Data Firehose
- Fully managed, serverless service with automatic scaling.
- Integrations: AWS (Redshift, S3, OpenSearch), third-party (Splunk, MongoDB, DataDog, NewRelic), custom HTTP endpoints.
- Pay for data throughput.
- **Buffering**: Interval from 0 to 900 seconds, size minimum 1 MB.
- Supports various data formats, conversions, transformations, and compression.
- Custom data transformations via AWS Lambda.
- Backup failed or all data to an S3 bucket.