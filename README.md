# localstack_dashboard_client

local stack dashboard implemented with flutter + riverpod

Currently under development for SQS. The todo list will be updated later.

## Screen Example

![sqs_sample.png](assets/sqs_sample.png)


## Error Case
- The request client is not a secure context and the resource is in more-private address space `local`.
    ```
    chrome: chrome://flags/#block-insecure-private-network-requests -> disabled
    edge: edge://flags/#block-insecure-private-network-requests -> disabled
    ```
