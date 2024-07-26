# AWS API Gateway

## Overview
AWS API Gateway is a serverless service for creating, publishing, maintaining, monitoring, and securing APIs. It acts as a "front door" for applications to access data, business logic, or functionality from your backend services, such as applications running on Amazon EC2, code running on AWS Lambda, or any web application.

## Communication Types

### Lambda Function
- **Invoke Lambda Function**: Expose REST APIs backed by AWS Lambda functions.
- **Use Cases**: Easy to deploy and manage serverless REST APIs.

### HTTP
- **Expose HTTP Endpoints**: Connect API Gateway to backend HTTP endpoints.
- **Use Cases**: Integrate internal HTTP APIs, on-premises applications, or services behind an Application Load Balancer. Add features like rate limiting, caching, user authentication, and API keys.

### AWS Service
- **Expose AWS APIs**: Use API Gateway to call other AWS services.
- **Use Cases**: Start AWS Step Function workflows, post messages to SQS, etc. Add authentication, public deployment, and rate control.

## Stages and Deployments

### Stages
- **Stages**: Deploy API changes to different stages (e.g., dev, test, prod).
- **Configuration**: Each stage has its own configuration parameters.
- **Rollback**: Deployment history is maintained, allowing rollback to previous stages.
- **Stage Variables**: Environment variables for API Gateway, used to change configuration values often. They can be used in Lambda function ARNs, HTTP endpoints, and parameter mapping templates.

### Canary Deployments
- **Canary Deployment**: Gradually deploy new changes to a small percentage of users before rolling out to everyone.
- **Configuration**: Enable canary in the deployment, set canary and production percentages.
- **Promotion**: Promote the canary deployment to production after testing.

## Integration Types

### MOCK
- **MOCK**: API Gateway returns a response without sending the request to the backend.

### AWS_PROXY
- **AWS_PROXY**: Direct integration with AWS services.

### HTTP_PROXY
- **HTTP_PROXY**: Integrate with HTTP endpoints, allowing the addition of HTTP headers if needed (e.g., API key).

## Mapping Templates
- **Mapping Templates**: Transform requests to the backend and responses back to the client. Useful for transforming data formats (e.g., XML to JSON, JSON to XML).

## OpenAPI and Swagger
- **OpenAPI/Swagger**: Directly import API specifications to configure API Gateway. Additional parameters in specifications can validate requests and return errors for improper requests.

## Caching
- **Caching**: Reduce the number of calls to the backend.
  - **TTL (Time to Live)**: Default is 300 seconds (min: 0s, max: 3600s).
  - **Per Stage**: Caches are defined per stage.
  - **Override Settings**: Possible to override cache settings per method.
  - **Capacity**: Cache capacity ranges from 0.5GB to 237GB.
  - **Invalidate Cache**: Clients can invalidate the cache with the `Cache-Control: max-age=0` header (with proper IAM authorization).

## Cross-Origin Resource Sharing (CORS)
- **CORS**: Enable CORS to receive API calls from another domain.
  - **Headers**: `Access-Control-Allow-Methods`, `Access-Control-Allow-Headers`, `Access-Control-Allow-Origin`.
  - **Configuration**: Can be enabled through the console.

## Gateway Authorizers

### IAM
- **IAM Authorizer**: Suitable for users/roles within your AWS account. Manages authentication and authorization using Signature v4.

### Custom Authorizer
- **Custom Authorizer**: Ideal for third-party tokens. Allows flexibility in returned IAM policies. Handles authentication and authorization within a Lambda function.

### Cognito User Pool
- **Cognito User Pool**: Manages user pools, possibly backed by Facebook, Google login, etc. No custom code required. Authorization is implemented in the backend.

## WebSocket API
- **WebSocket APIs**: Used in real-time applications like chat applications, collaboration platforms, multiplayer games, and financial trading platforms.
  - **Backend Integration**: Works with AWS Services (Lambda, DynamoDB) or HTTP endpoints.
  - **Operations**:
    - **POST**: Send a message from the server to the connected WebSocket client.
    - **GET**: Get the latest connection status of the connected WebSocket client.
    - **DELETE**: Disconnect the connected client from the WebSocket connection.
  - **Routing**: Incoming JSON messages are routed to different backends based on a route selection expression.
