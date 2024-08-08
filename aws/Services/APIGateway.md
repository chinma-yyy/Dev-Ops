# AWS API Gateway

## Overview
AWS API Gateway is a serverless service to manage all the APIs, and we can communicate with this gateway using various methods like Lambda functions, HTTP endpoints, and AWS services.

## Communication Types

### Lambda Function
- **Invoke Lambda Function**: Easy way to expose REST API backed by AWS Lambda.
  - **Use Case**: Exposing serverless functions via a REST API.

### HTTP
- **Expose HTTP Endpoints**: Expose HTTP endpoints in the backend.
  - **Example**: Internal HTTP API on-premises, Application Load Balancer.
  - **Why**: Add rate limiting, caching, user authentications, API keys, etc.

### AWS Service
- **Expose any AWS API through the API Gateway**: 
  - **Example**: Start an AWS Step Function workflow, post a message to SQS.
  - **Why**: Add authentication, deploy publicly, rate control.

## Stages and Deployments

### Stages
- **Stages**: Making changes in the API Gateway does not mean they’re effective; you need to make a “deployment” for them to be in effect.
  - **Common Source of Confusion**: Changes are deployed to “Stages” (as many as you want).
  - **Naming**: Use the naming you like for stages (dev, test, prod).
  - **Configuration Parameters**: Each stage has its own configuration parameters.
  - **Rollback**: Stages can be rolled back as a history of deployments is kept.

- **Stage Variables**: Like environment variables for API Gateway.
  - **Use Cases**: Change often-changing configuration values.
  - **Applications**: Configure HTTP endpoints your stages talk to (dev, test, prod), pass configuration parameters to AWS Lambda through mapping templates.
  - **Access in Lambda**: Stage variables are passed to the ”context” object in AWS Lambda.
  - **Format**: `${stageVariables.variableName}`.

### Canary Deployment
- **Canary Deployment**: Distribute traffic based on weights on Lambda aliases.
  - **Process**: 
    1. Enable canary in the deployment.
    2. Add the canary percentage and prod percentage.
    3. Deploy a canary version; the percentage to canary is diverted accordingly.
    4. Promote the canary, making it the new prod.

## Integration Types

### Integration Type MOCK
- **MOCK**: API Gateway returns a response without sending the request to the backend.

### Integration Type AWS_PROXY
- **AWS_PROXY**: Direct input to the resource.

### Integration Type HTTP_PROXY
- **HTTP_PROXY**: Add HTTP headers if needed (e.g., API key).

## Mapping Templates
- **Mapping Templates**: Transform the requests going to the resource or the responses coming out of the resource going back to the client.
  - **Use Cases**: Transform from XML to JSON or JSON to XML in cases of SOAP API to REST API scenarios.

## OpenAPI and Swagger
- **OpenAPI/Swagger**: Directly import OpenAPI or Swagger specification files and configure your API Gateway.
  - **Additional Parameters**: Validate the request and return an error if the request does not have the proper attributes.

## Caching
- **Caching**: Reduces the number of calls made to the backend.
  - **TTL**: Default TTL (time to live) is 300 seconds (min: 0s, max: 3600s).
  - **Stage-based**: Caches are defined per stage.
  - **Override Settings**: Possible to override cache settings per method.
  - **Capacity**: Cache capacity ranges from 0.5GB to 237GB.
  - **Invalidate Cache**: Clients can invalidate the cache with the header `Cache-Control: max-age=0` (with proper IAM authorization).

## Cross-Origin Resource Sharing (CORS)
- **CORS**: Must be enabled when you receive API calls from another domain.
  - **Pre-flight Request Headers**: 
    - `Access-Control-Allow-Methods`
    - `Access-Control-Allow-Headers`
    - `Access-Control-Allow-Origin`
  - **Configuration**: Can be enabled through the console.

## Gateway Authorizer

### IAM
- **IAM Authorizer**: Great for users/roles already within your AWS account, plus resource policy for cross-account access.
  - **Features**: Handle authentication and authorization, leverages Signature v4.

### Custom Authorizer
- **Custom Authorizer**: Great for third-party tokens.
  - **Features**: Flexible in terms of IAM policy returned, handles authentication verification and authorization in the Lambda function. Pay per Lambda invocation, results are cached.

### Cognito User Pool
- **Cognito User Pool**: Manage your own user pool (can be backed by Facebook, Google login, etc.).
  - **Features**: No need to write custom code, must implement authorization in the backend.

## WebSocket API
- **WebSocket APIs**: Used in real-time applications such as chat applications, collaboration platforms, multiplayer games, and financial trading platforms.
  - **Backend Integration**: Works with AWS Services (Lambda, DynamoDB) or HTTP endpoints.
  - **Operations**: 
    - `POST`: Sends a message from the server to the connected WebSocket client.
    - `GET`: Gets the latest connection status of the connected WebSocket client.
    - `DELETE`: Disconnects the connected client from the WebSocket connection.
  - **Routing**: Incoming JSON messages are routed to different backend services. If no routes are defined, messages are sent to `$default`.
  - **Route Selection Expression**: You request a route selection expression to select the field on JSON to route from.
    - **Example**: `$request.body.action`
