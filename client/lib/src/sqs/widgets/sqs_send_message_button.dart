import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/sqs/dialogs/sqs_send_message_dialog.dart';
import 'package:cloud_dashboard_client/src/sqs/models/sqs_message_create.dart';
import 'package:cloud_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:cloud_dashboard_client/src/sqs/sqs_provider_mapper.dart';

class SqsSendMessageButton extends HookConsumerWidget {
  final ModelSqsQueueInfo queue;

  const SqsSendMessageButton({Key? key, required this.queue}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () async {
          // fifo messageGroupId
          final sqsService =
              ref.watch(SQSProviderMapper.getSqsServiceProvider(queue));
          final ModelSqsMessageCreate? message = await showSQSSendMessageDialog(
            context,
            isFifo: queue.queueUrl.endsWith(".fifo"),
          );
          if (message == null) return;
          final content = message.isEncodeToBase64
              ? base64.encode(utf8.encode(message.messageContent))
              : message.messageContent;
          await sqsService.sendMessage(
              messageBody: content,
              queueUrl: queue.queueUrl,
              messageGroupId: message.messageGroupId,
              messageDeduplicationId:
                  message.messageGroupId != null ? "asdf" : null);

          ref.refresh(SQSProviderMapper.detailFutureProvider(queue));
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("SendMessage"),
        ),
      ),
    );
  }
}
