// import 'package:aws_sqs_api/sqs-2012-11-05.dart';
// import 'package:mockito/mockito.dart';
// import 'package:shared_aws_api/src/model/shape.dart';
//
// class MockSQS extends Mock implements SQS {
//   @override
//   Future<void> addPermission(
//       {required List<String> awsAccountIds,
//       required List<String> actions,
//       required String label,
//       required String queueUrl}) {
//     // TODO: implement addPermission
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> changeMessageVisibility(
//       {required String queueUrl,
//       required String receiptHandle,
//       required int visibilityTimeout}) {
//     // TODO: implement changeMessageVisibility
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<ChangeMessageVisibilityBatchResult> changeMessageVisibilityBatch(
//       {required List<ChangeMessageVisibilityBatchRequestEntry> entries,
//       required String queueUrl}) {
//     // TODO: implement changeMessageVisibilityBatch
//     throw UnimplementedError();
//   }
//
//   @override
//   void close() {
//     // TODO: implement close
//   }
//
//   @override
//   Future<CreateQueueResult> createQueue(
//       {required String queueName,
//       Map<QueueAttributeName, String>? attributes,
//       Map<String, String>? tags}) {
//     // TODO: implement createQueue
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> deleteMessage(
//       {required String queueUrl, required String receiptHandle}) {
//     // TODO: implement deleteMessage
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<DeleteMessageBatchResult> deleteMessageBatch(
//       {required List<DeleteMessageBatchRequestEntry> entries,
//       required String queueUrl}) {
//     // TODO: implement deleteMessageBatch
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> deleteQueue({required String queueUrl}) {
//     // TODO: implement deleteQueue
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<GetQueueAttributesResult> getQueueAttributes(
//       {required String queueUrl, List<QueueAttributeName>? attributeNames}) {
//     // TODO: implement getQueueAttributes
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<GetQueueUrlResult> getQueueUrl(
//       {required String queueName, String? queueOwnerAWSAccountId}) {
//     // TODO: implement getQueueUrl
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<ListDeadLetterSourceQueuesResult> listDeadLetterSourceQueues(
//       {required String queueUrl, int? maxResults, String? nextToken}) {
//     // TODO: implement listDeadLetterSourceQueues
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<ListQueueTagsResult> listQueueTags({required String queueUrl}) {
//     // TODO: implement listQueueTags
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<ListQueuesResult> listQueues(
//       {int? maxResults, String? nextToken, String? queueNamePrefix}) {
//     // TODO: implement listQueues
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> purgeQueue({required String queueUrl}) {
//     // TODO: implement purgeQueue
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<ReceiveMessageResult> receiveMessage(
//       {required String queueUrl,
//       List<QueueAttributeName>? attributeNames,
//       int? maxNumberOfMessages,
//       List<String>? messageAttributeNames,
//       String? receiveRequestAttemptId,
//       int? visibilityTimeout,
//       int? waitTimeSeconds}) {
//     // TODO: implement receiveMessage
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> removePermission(
//       {required String label, required String queueUrl}) {
//     // TODO: implement removePermission
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<SendMessageResult> sendMessage(
//       {required String messageBody,
//       required String queueUrl,
//       int? delaySeconds,
//       Map<String, MessageAttributeValue>? messageAttributes,
//       String? messageDeduplicationId,
//       String? messageGroupId,
//       Map<MessageSystemAttributeNameForSends, MessageSystemAttributeValue>?
//           messageSystemAttributes}) {
//     // TODO: implement sendMessage
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<SendMessageBatchResult> sendMessageBatch(
//       {required List<SendMessageBatchRequestEntry> entries,
//       required String queueUrl}) {
//     // TODO: implement sendMessageBatch
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> setQueueAttributes(
//       {required Map<QueueAttributeName, String> attributes,
//       required String queueUrl}) {
//     // TODO: implement setQueueAttributes
//     throw UnimplementedError();
//   }
//
//   @override
//   // TODO: implement shapes
//   Map<String, Shape> get shapes => throw UnimplementedError();
//
//   @override
//   Future<void> tagQueue(
//       {required String queueUrl, required Map<String, String> tags}) {
//     // TODO: implement tagQueue
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> untagQueue(
//       {required String queueUrl, required List<String> tagKeys}) {
//     // TODO: implement untagQueue
//     throw UnimplementedError();
//   }
// }
