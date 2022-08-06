import 'dart:convert';

import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/enums.dart';
import 'package:localstack_dashboard_client/src/sqs/models/create.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/service_provider.dart';
import 'package:localstack_dashboard_client/src/utils/dialog_utils.dart';

final sqsDetailProvider =
    FutureProvider.family<Map<QueueAttributeName, String>, String>(
        (ref, queueUrl) async {
  final sqsService = ref.watch(sqsServiceProvider);
  final GetQueueAttributesResult rs = await sqsService.getQueueAttributes(
      queueUrl: queueUrl, attributeNames: [QueueAttributeName.all]);
  return rs.attributes!;
});

final sqsDetailStateProvider =
    StateProvider.family<Map<QueueAttributeName, String>, String>(
        (ref, queueUrl) {
  return <QueueAttributeName, String>{};
});

class SqsDetail extends HookConsumerWidget {
  final String queueUrl;

  const SqsDetail({Key? key, required this.queueUrl}) : super(key: key);

  refresh(WidgetRef ref) async {
    ref.refresh(sqsDetailProvider(queueUrl));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      ref.listen(sqsDetailProvider(queueUrl), (previous, next) {
        if (next is AsyncData) {
          ref.read(sqsDetailStateProvider(queueUrl).state).state = next.value!;
        }
      });
    } catch (e) {
      print(e);
    }

    final info = ref.watch(sqsDetailStateProvider(queueUrl));

    return buildDetailInfo(context, ref, info);
  }

  Widget buildDetailInfo(BuildContext context, WidgetRef ref,
      Map<QueueAttributeName, String> sqsDetail) {
    final sqsService = ref.watch(sqsServiceProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildSendMessage(context, sqsService, ref),
              buildReceiveMessage(context, sqsService, ref),
              Card(
                child: InkWell(
                  onTap: () async {
                    await sqsService.purgeQueue(queueUrl: queueUrl);
                    refresh(ref);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Purge"),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    refresh(ref);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.refresh),
                  ),
                ),
              ),
            ],
          ),
          ...sqsDetail.entries.map(
            (e) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key.name),
                  Text(e.value),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildSendMessage(BuildContext context, SQS sqsService, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () async {
          final ModelSqsMessageCreate? message =
              await showSQSSendMessageDialog(context);
          if (message == null) return;
          final content = message.isEncodeToBase64
              ? base64.encode(utf8.encode(message.messageContent))
              : message.messageContent;
          await sqsService.sendMessage(
              messageBody: content, queueUrl: queueUrl);
          refresh(ref);
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("SendMessage"),
        ),
      ),
    );
  }

  Widget buildReceiveMessage(
      BuildContext context, SQS sqsService, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () async {
          final Future<ReceiveMessageResult> receivedMessage =
              sqsService.receiveMessage(queueUrl: queueUrl);
          refresh(ref);
          final SQSReceiveMessageActionEnum receiveMessageAction =
              await showSQSReceiveMessageResultDialog(context, receivedMessage,
                      buildReceiveMessageDialogContent) ??
                  SQSReceiveMessageActionEnum.rollback;

          if (receiveMessageAction == SQSReceiveMessageActionEnum.rollback) {
            final value = (await receivedMessage).messages!.first;
            await sqsService.changeMessageVisibility(
                queueUrl: queueUrl,
                receiptHandle: value.receiptHandle!,
                visibilityTimeout: 0);
          }

          // if receiveMessageAction == SQSReceiveMessageActionEnum.ignore,
          // do not any action.
          // received message will be NotVisible

          if (receiveMessageAction == SQSReceiveMessageActionEnum.delete) {
            final value = (await receivedMessage).messages!.first;
            await sqsService.deleteMessage(
                queueUrl: queueUrl, receiptHandle: value.receiptHandle!);
          }

          refresh(ref);
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("ReceiveMessage"),
        ),
      ),
    );
  }

  buildReceiveMessageDialogContent(ReceiveMessageResult value) {
    final message = value.messages!.first;
    String messageBody;
    bool isBase64Body = false;
    try {
      messageBody = utf8.decode(base64.decode(message.body!));
      isBase64Body = true;
    } catch (e) {
      messageBody = message.body!;
      isBase64Body = false;
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "MessageId",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Card(
              child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(message.messageId!),
          )),
          Container(
            padding: const EdgeInsets.all(4),
            height: 1,
            width: double.infinity,
          ),
          Text(
            "Body ${isBase64Body ? "(base64 decoded)" : ""}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(messageBody),
            ),
          ),
        ],
      ),
    );
  }
}
