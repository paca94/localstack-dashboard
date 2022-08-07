import 'dart:convert';

import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/enums.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:localstack_dashboard_client/src/sqs/sqs_provider_mapper.dart';
import 'package:localstack_dashboard_client/src/utils/dialog_utils.dart';
import 'package:localstack_dashboard_client/src/widgets/card_button.dart';

class SqsReceiveMessageButton extends HookConsumerWidget {
  final ModelSqsQueueInfo queue;

  const SqsReceiveMessageButton({Key? key, required this.queue})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return CardButton(
      onTap: () async {
        final sqsService =
            ref.watch(SQSProviderMapper.getSqsServiceProvider(queue));
        final Future<ReceiveMessageResult> receivedMessage =
            sqsService.receiveMessage(queueUrl: queue.queueUrl);
        ref.refresh(SQSProviderMapper.detailFutureProvider(queue));

        final SQSReceiveMessageActionEnum receiveMessageAction =
            await showSQSReceiveMessageResultDialog(context, receivedMessage,
                    buildReceiveMessageDialogContent) ??
                SQSReceiveMessageActionEnum.rollback;

        if (receiveMessageAction == SQSReceiveMessageActionEnum.rollback) {
          final value = (await receivedMessage).messages!.first;
          await sqsService.changeMessageVisibility(
              queueUrl: queue.queueUrl,
              receiptHandle: value.receiptHandle!,
              visibilityTimeout: 0);
        }

        // if receiveMessageAction == SQSReceiveMessageActionEnum.ignore,
        // do not any action.
        // received message will be NotVisible

        if (receiveMessageAction == SQSReceiveMessageActionEnum.delete) {
          final value = (await receivedMessage).messages!.first;
          await sqsService.deleteMessage(
              queueUrl: queue.queueUrl, receiptHandle: value.receiptHandle!);
        }

        ref.refresh(SQSProviderMapper.detailFutureProvider(queue));
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("ReceiveMessage"),
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
