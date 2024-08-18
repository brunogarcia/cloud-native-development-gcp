# Project 5: API and User Interface with API Gateway and Cloud Storage

[https://github.com/SkillsMapper/skillsmapper/tree/main/user-interface](https://github.com/SkillsMapper/skillsmapper/tree/main/user-interface)

In order to secure the system and streamline its operation, unifying the services under a single, secure API.

Additionally, you will deploy a user interface, providing users with a secure and consolidated point of access to the Skills Mapper application’s functionality.

## OpenAPI

To bring together multiple services under a single API, you can define a common API using the OpenAPI specification. You can then use that as the configuration for a Google Cloud API Gateway.

The great thing about using an OpenAPI specification is that only the specific endpoints explicitly defined will be exposed via the API Gateway. This has a security benefit; it means that any endpoints not defined in the specification will not be exposed.

## API Gateway

Google API Gateway is a managed service that is intended to allow you to expose your APIs to the internet. It is a fully managed service that handles the scaling and load balancing of your APIs. It also provides several features such as authentication, rate limiting, and monitoring.
