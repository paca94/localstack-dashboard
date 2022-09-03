// Mocks generated by Mockito 5.3.0 from annotations
// in localstack_dashboard_client/test/sqs/providers/sqs_detail_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:aws_sqs_api/sqs-2012-11-05.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:shared_aws_api/shared.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeChangeMessageVisibilityBatchResult_0 extends _i1.SmartFake
    implements _i2.ChangeMessageVisibilityBatchResult {
  _FakeChangeMessageVisibilityBatchResult_0(
      Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeCreateQueueResult_1 extends _i1.SmartFake
    implements _i2.CreateQueueResult {
  _FakeCreateQueueResult_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeDeleteMessageBatchResult_2 extends _i1.SmartFake
    implements _i2.DeleteMessageBatchResult {
  _FakeDeleteMessageBatchResult_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetQueueAttributesResult_3 extends _i1.SmartFake
    implements _i2.GetQueueAttributesResult {
  _FakeGetQueueAttributesResult_3(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetQueueUrlResult_4 extends _i1.SmartFake
    implements _i2.GetQueueUrlResult {
  _FakeGetQueueUrlResult_4(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeListDeadLetterSourceQueuesResult_5 extends _i1.SmartFake
    implements _i2.ListDeadLetterSourceQueuesResult {
  _FakeListDeadLetterSourceQueuesResult_5(
      Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeListQueueTagsResult_6 extends _i1.SmartFake
    implements _i2.ListQueueTagsResult {
  _FakeListQueueTagsResult_6(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeListQueuesResult_7 extends _i1.SmartFake
    implements _i2.ListQueuesResult {
  _FakeListQueuesResult_7(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeReceiveMessageResult_8 extends _i1.SmartFake
    implements _i2.ReceiveMessageResult {
  _FakeReceiveMessageResult_8(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeSendMessageResult_9 extends _i1.SmartFake
    implements _i2.SendMessageResult {
  _FakeSendMessageResult_9(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeSendMessageBatchResult_10 extends _i1.SmartFake
    implements _i2.SendMessageBatchResult {
  _FakeSendMessageBatchResult_10(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [SQS].
///
/// See the documentation for Mockito's code generation for more information.
class MockSQS extends _i1.Mock implements _i2.SQS {
  MockSQS() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, _i3.Shape> get shapes =>
      (super.noSuchMethod(Invocation.getter(#shapes),
          returnValue: <String, _i3.Shape>{}) as Map<String, _i3.Shape>);
  @override
  void close() => super.noSuchMethod(Invocation.method(#close, []),
      returnValueForMissingStub: null);
  @override
  _i4.Future<void> addPermission(
          {List<String>? awsAccountIds,
          List<String>? actions,
          String? label,
          String? queueUrl}) =>
      (super.noSuchMethod(
              Invocation.method(#addPermission, [], {
                #awsAccountIds: awsAccountIds,
                #actions: actions,
                #label: label,
                #queueUrl: queueUrl
              }),
              returnValue: _i4.Future<void>.value(),
              returnValueForMissingStub: _i4.Future<void>.value())
          as _i4.Future<void>);
  @override
  _i4.Future<void> changeMessageVisibility(
          {String? queueUrl, String? receiptHandle, int? visibilityTimeout}) =>
      (super.noSuchMethod(
              Invocation.method(#changeMessageVisibility, [], {
                #queueUrl: queueUrl,
                #receiptHandle: receiptHandle,
                #visibilityTimeout: visibilityTimeout
              }),
              returnValue: _i4.Future<void>.value(),
              returnValueForMissingStub: _i4.Future<void>.value())
          as _i4.Future<void>);
  @override
  _i4.Future<_i2.ChangeMessageVisibilityBatchResult> changeMessageVisibilityBatch(
          {List<_i2.ChangeMessageVisibilityBatchRequestEntry>? entries,
          String? queueUrl}) =>
      (super.noSuchMethod(Invocation.method(#changeMessageVisibilityBatch, [], {#entries: entries, #queueUrl: queueUrl}),
          returnValue: _i4.Future<_i2.ChangeMessageVisibilityBatchResult>.value(
              _FakeChangeMessageVisibilityBatchResult_0(
                  this,
                  Invocation.method(#changeMessageVisibilityBatch, [], {
                    #entries: entries,
                    #queueUrl: queueUrl
                  })))) as _i4.Future<_i2.ChangeMessageVisibilityBatchResult>);
  @override
  _i4.Future<_i2.CreateQueueResult> createQueue(
          {String? queueName,
          Map<_i2.QueueAttributeName, String>? attributes,
          Map<String, String>? tags}) =>
      (super.noSuchMethod(Invocation.method(#createQueue, [], {#queueName: queueName, #attributes: attributes, #tags: tags}),
          returnValue: _i4.Future<_i2.CreateQueueResult>.value(
              _FakeCreateQueueResult_1(
                  this,
                  Invocation.method(#createQueue, [], {
                    #queueName: queueName,
                    #attributes: attributes,
                    #tags: tags
                  })))) as _i4.Future<_i2.CreateQueueResult>);
  @override
  _i4.Future<void> deleteMessage({String? queueUrl, String? receiptHandle}) =>
      (super.noSuchMethod(
              Invocation.method(#deleteMessage, [],
                  {#queueUrl: queueUrl, #receiptHandle: receiptHandle}),
              returnValue: _i4.Future<void>.value(),
              returnValueForMissingStub: _i4.Future<void>.value())
          as _i4.Future<void>);
  @override
  _i4.Future<_i2.DeleteMessageBatchResult> deleteMessageBatch(
          {List<_i2.DeleteMessageBatchRequestEntry>? entries,
          String? queueUrl}) =>
      (super.noSuchMethod(Invocation.method(#deleteMessageBatch, [], {#entries: entries, #queueUrl: queueUrl}),
          returnValue: _i4.Future<_i2.DeleteMessageBatchResult>.value(
              _FakeDeleteMessageBatchResult_2(
                  this,
                  Invocation.method(#deleteMessageBatch, [], {
                    #entries: entries,
                    #queueUrl: queueUrl
                  })))) as _i4.Future<_i2.DeleteMessageBatchResult>);
  @override
  _i4.Future<void> deleteQueue({String? queueUrl}) => (super.noSuchMethod(
      Invocation.method(#deleteQueue, [], {#queueUrl: queueUrl}),
      returnValue: _i4.Future<void>.value(),
      returnValueForMissingStub: _i4.Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<_i2.GetQueueAttributesResult> getQueueAttributes(
          {String? queueUrl, List<_i2.QueueAttributeName>? attributeNames}) =>
      (super.noSuchMethod(Invocation.method(#getQueueAttributes, [], {#queueUrl: queueUrl, #attributeNames: attributeNames}),
          returnValue: _i4.Future<_i2.GetQueueAttributesResult>.value(
              _FakeGetQueueAttributesResult_3(
                  this,
                  Invocation.method(#getQueueAttributes, [], {
                    #queueUrl: queueUrl,
                    #attributeNames: attributeNames
                  })))) as _i4.Future<_i2.GetQueueAttributesResult>);
  @override
  _i4.Future<_i2.GetQueueUrlResult> getQueueUrl(
          {String? queueName, String? queueOwnerAWSAccountId}) =>
      (super.noSuchMethod(Invocation.method(#getQueueUrl, [], {#queueName: queueName, #queueOwnerAWSAccountId: queueOwnerAWSAccountId}),
          returnValue: _i4.Future<_i2.GetQueueUrlResult>.value(
              _FakeGetQueueUrlResult_4(
                  this,
                  Invocation.method(#getQueueUrl, [], {
                    #queueName: queueName,
                    #queueOwnerAWSAccountId: queueOwnerAWSAccountId
                  })))) as _i4.Future<_i2.GetQueueUrlResult>);
  @override
  _i4.Future<_i2.ListDeadLetterSourceQueuesResult> listDeadLetterSourceQueues(
          {String? queueUrl, int? maxResults, String? nextToken}) =>
      (super.noSuchMethod(Invocation.method(#listDeadLetterSourceQueues, [], {#queueUrl: queueUrl, #maxResults: maxResults, #nextToken: nextToken}),
          returnValue: _i4.Future<_i2.ListDeadLetterSourceQueuesResult>.value(
              _FakeListDeadLetterSourceQueuesResult_5(
                  this,
                  Invocation.method(#listDeadLetterSourceQueues, [], {
                    #queueUrl: queueUrl,
                    #maxResults: maxResults,
                    #nextToken: nextToken
                  })))) as _i4.Future<_i2.ListDeadLetterSourceQueuesResult>);
  @override
  _i4.Future<_i2.ListQueueTagsResult> listQueueTags({String? queueUrl}) =>
      (super.noSuchMethod(
              Invocation.method(#listQueueTags, [], {#queueUrl: queueUrl}),
              returnValue: _i4.Future<_i2.ListQueueTagsResult>.value(
                  _FakeListQueueTagsResult_6(
                      this,
                      Invocation.method(
                          #listQueueTags, [], {#queueUrl: queueUrl}))))
          as _i4.Future<_i2.ListQueueTagsResult>);
  @override
  _i4.Future<_i2.ListQueuesResult> listQueues(
          {int? maxResults, String? nextToken, String? queueNamePrefix}) =>
      (super.noSuchMethod(
          Invocation.method(#listQueues, [], {
            #maxResults: maxResults,
            #nextToken: nextToken,
            #queueNamePrefix: queueNamePrefix
          }),
          returnValue:
              _i4.Future<_i2.ListQueuesResult>.value(_FakeListQueuesResult_7(
                  this,
                  Invocation.method(#listQueues, [], {
                    #maxResults: maxResults,
                    #nextToken: nextToken,
                    #queueNamePrefix: queueNamePrefix
                  })))) as _i4.Future<_i2.ListQueuesResult>);
  @override
  _i4.Future<void> purgeQueue({String? queueUrl}) => (super.noSuchMethod(
      Invocation.method(#purgeQueue, [], {#queueUrl: queueUrl}),
      returnValue: _i4.Future<void>.value(),
      returnValueForMissingStub: _i4.Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<_i2.ReceiveMessageResult> receiveMessage(
          {String? queueUrl,
          List<_i2.QueueAttributeName>? attributeNames,
          int? maxNumberOfMessages,
          List<String>? messageAttributeNames,
          String? receiveRequestAttemptId,
          int? visibilityTimeout,
          int? waitTimeSeconds}) =>
      (super.noSuchMethod(
          Invocation.method(#receiveMessage, [], {
            #queueUrl: queueUrl,
            #attributeNames: attributeNames,
            #maxNumberOfMessages: maxNumberOfMessages,
            #messageAttributeNames: messageAttributeNames,
            #receiveRequestAttemptId: receiveRequestAttemptId,
            #visibilityTimeout: visibilityTimeout,
            #waitTimeSeconds: waitTimeSeconds
          }),
          returnValue: _i4.Future<_i2.ReceiveMessageResult>.value(
              _FakeReceiveMessageResult_8(
                  this,
                  Invocation.method(#receiveMessage, [], {
                    #queueUrl: queueUrl,
                    #attributeNames: attributeNames,
                    #maxNumberOfMessages: maxNumberOfMessages,
                    #messageAttributeNames: messageAttributeNames,
                    #receiveRequestAttemptId: receiveRequestAttemptId,
                    #visibilityTimeout: visibilityTimeout,
                    #waitTimeSeconds: waitTimeSeconds
                  })))) as _i4.Future<_i2.ReceiveMessageResult>);
  @override
  _i4.Future<void> removePermission({String? label, String? queueUrl}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #removePermission, [], {#label: label, #queueUrl: queueUrl}),
              returnValue: _i4.Future<void>.value(),
              returnValueForMissingStub: _i4.Future<void>.value())
          as _i4.Future<void>);
  @override
  _i4.Future<_i2.SendMessageResult> sendMessage(
          {String? messageBody,
          String? queueUrl,
          int? delaySeconds,
          Map<String, _i2.MessageAttributeValue>? messageAttributes,
          String? messageDeduplicationId,
          String? messageGroupId,
          Map<_i2.MessageSystemAttributeNameForSends,
                  _i2.MessageSystemAttributeValue>?
              messageSystemAttributes}) =>
      (super.noSuchMethod(
          Invocation.method(#sendMessage, [], {
            #messageBody: messageBody,
            #queueUrl: queueUrl,
            #delaySeconds: delaySeconds,
            #messageAttributes: messageAttributes,
            #messageDeduplicationId: messageDeduplicationId,
            #messageGroupId: messageGroupId,
            #messageSystemAttributes: messageSystemAttributes
          }),
          returnValue:
              _i4.Future<_i2.SendMessageResult>.value(_FakeSendMessageResult_9(
                  this,
                  Invocation.method(#sendMessage, [], {
                    #messageBody: messageBody,
                    #queueUrl: queueUrl,
                    #delaySeconds: delaySeconds,
                    #messageAttributes: messageAttributes,
                    #messageDeduplicationId: messageDeduplicationId,
                    #messageGroupId: messageGroupId,
                    #messageSystemAttributes: messageSystemAttributes
                  })))) as _i4.Future<_i2.SendMessageResult>);
  @override
  _i4.Future<_i2.SendMessageBatchResult> sendMessageBatch(
          {List<_i2.SendMessageBatchRequestEntry>? entries,
          String? queueUrl}) =>
      (super.noSuchMethod(Invocation.method(#sendMessageBatch, [], {#entries: entries, #queueUrl: queueUrl}),
          returnValue: _i4.Future<_i2.SendMessageBatchResult>.value(
              _FakeSendMessageBatchResult_10(
                  this,
                  Invocation.method(#sendMessageBatch, [], {
                    #entries: entries,
                    #queueUrl: queueUrl
                  })))) as _i4.Future<_i2.SendMessageBatchResult>);
  @override
  _i4.Future<void> setQueueAttributes(
          {Map<_i2.QueueAttributeName, String>? attributes,
          String? queueUrl}) =>
      (super.noSuchMethod(
              Invocation.method(#setQueueAttributes, [],
                  {#attributes: attributes, #queueUrl: queueUrl}),
              returnValue: _i4.Future<void>.value(),
              returnValueForMissingStub: _i4.Future<void>.value())
          as _i4.Future<void>);
  @override
  _i4.Future<void> tagQueue({String? queueUrl, Map<String, String>? tags}) =>
      (super.noSuchMethod(
          Invocation.method(#tagQueue, [], {#queueUrl: queueUrl, #tags: tags}),
          returnValue: _i4.Future<void>.value(),
          returnValueForMissingStub:
              _i4.Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> untagQueue({String? queueUrl, List<String>? tagKeys}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #untagQueue, [], {#queueUrl: queueUrl, #tagKeys: tagKeys}),
              returnValue: _i4.Future<void>.value(),
              returnValueForMissingStub: _i4.Future<void>.value())
          as _i4.Future<void>);
}
