# AWS CloudWatch

## Metrics
- Metrics allow you to collect and track key data from AWS resources.
- A metric has a namespace, which is a collection of related metrics.
- Metrics have dimensions, which are attributes used to identify and create metrics for specific resources.
- Metrics can only be created using the CLI or API, not the UI.
- There are multiple options to create a metric, including using JSON to define the metric.
## Metric Filters
- Metric filters allow you to create metrics based on specific patterns in the logs.
- By defining patterns, you can extract relevant data and generate resulting metrics.

## Subscription Filters
- Subscription filters forward logs that match specific patterns to AWS Lambda or other destinations.
- A log group can have up to two subscription filters.

## Anomaly Detection
- Anomaly detectors can identify anomalies in logs based on defined patterns.
## Dashboards
- Dashboards are customizable and display the metrics you choose.
- You can add specific metrics to a dashboard, including those from automatic dashboards.
- Previous dashboards can be automatically generated.

## Metric Streams
- Metric streams allow you to send metrics from AWS to a specific location, such as a third-party service, S3, or AWS Firehose.
- To set up a metric stream, you need to specify the namespace and metrics you want to send to the destination.

## Logs
- CloudWatch Logs collects, monitors, analyzes, and stores log files.
- Logs are organized into log groups.
- Each log group can have multiple log streams.
- CloudWatch Agents need to be installed on EC2 instances to monitor specific metrics and communicate using the API or SDK.
- Various metrics can be collected, such as CPU usage, disk metrics, RAM usage, network statistics, processes, and swap space.
## Live Tail
- Live Tail enables real-time viewing of selected logs from log groups and log streams.

## Alarms
- Alarms can be created based on metrics.
- Alarms can be triggered based on values such as sum, average, minimum, etc.
- You can configure actions when alarms are triggered, such as sending notifications to SNS topics or invoking Lambda functions.
- Composite alarms can monitor the states of multiple other alarms.
- Complex composite alarms can help reduce "alarm noise."
- CloudWatch Logs metrics filters can be used to create alarms.

# Amazon EventBridge (formerly CloudWatch Events)

- EventBridge allows you to send notifications when certain events happen in your AWS environment.
- It supports cron jobs, event rules, and triggers for tasks like invoking Lambda functions or sending events to SQS queues.
- Buses act as a tunnel for processing triggered events and can be custom or predefined.
- The schema registry defines the data schema used in your code.
- EventBridge can receive events from other AWS accounts and regions with the appropriate policies.

# AWS X-Ray

- X-Ray is a debugging tool implemented at the network layer.
- To enable X-Ray:
  - Import the AWS X-Ray SDK in your code (Java, Python, Go, Node.js, .NET).
  - Minimal code modifications are required.
  - The SDK captures calls to AWS services, HTTP/HTTPS requests, database calls, and queue calls.
- Install the X-Ray daemon or enable X-Ray AWS Integration:
  - The X-Ray daemon works as a low-level UDP packet interceptor.
  - For AWS Lambda and other AWS services, the X-Ray daemon is already provided.
  - Each application must have the appropriate IAM permissions to write data to X-Ray.
- Instrumentation is accomplished using the X-Ray SDK.
- Segments, subsegments, and traces provide structured data for analysis.
1. Sampling rules control the amount of data sent to X-Ray for tracing and analysis.
2. They help manage the volume of data and associated costs while still providing valuable insights.
3. By default, X-Ray applies a sampling algorithm to determine which requests and segments are captured.
4. Custom sampling rules allow you to define conditions and actions for different types of requests or segments.
5. You can set rules based on criteria like specific HTTP headers, user identities, or percentage-based sampling.
6. Rules are evaluated in order, and the first matching rule is applied, while subsequent rules are ignored.
7. Actions for rules can be "Sampled" (capture and send to X-Ray), "Not Sampled" (skip), or "Rule Decision" (evaluate next rule).
8. Sampling rules help strike a balance between capturing sufficient data for analysis and minimizing performance and cost impact.
# AWS Distro for OpenTelemetry

- AWS Distro for OpenTelemetry is a monitoring tool that integrates with AWS CloudWatch, X-Ray, and other partner solutions.
- It provides auto-instrumentation agents to collect traces without code modifications.
- Traces and metrics can be sent to multiple AWS services and partner solutions, such as X-Ray, CloudWatch, and Prometheus.
- Migrating from X-Ray to AWS Distro for OpenTelemetry allows standardization with open-source APIs and the ability to send traces to multiple destinations simultaneously.

# AWS CloudTrail

- CloudTrail logs all activities in AWS, including API calls from the console, SDKs, CLI, and IAM users.
- CloudTrail is enabled by default.
- Logs can be stored in CloudWatch Logs or S3.
- A trail can be applied to all regions or a single region.
- Investigate CloudTrail first when investigating resource deletions.
- Management events record operations performed on AWS resources.
- Data events, such as S3 object-level activity and Lambda function execution, can also be logged.
- CloudTrail Insights events detect unusual activity in your account.
