import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_message_create.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:localstack_dashboard_client/src/sqs/sqs_provider_mapper.dart';
import 'package:localstack_dashboard_client/src/utils/dialog_utils.dart';

class SqsSendMessageButton extends HookConsumerWidget {
  final ModelSqsQueueInfo queue;

  const SqsSendMessageButton({Key? key, required this.queue}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () async {
          final sqsService =
              ref.watch(SQSProviderMapper.getSqsServiceProvider(queue));
          final ModelSqsMessageCreate? message =
              await showSQSSendMessageDialog(context);
          if (message == null) return;
          final content = message.isEncodeToBase64
              ? base64.encode(utf8.encode(message.messageContent))
              : message.messageContent;
          await sqsService.sendMessage(
              messageBody: content, queueUrl: queue.queueUrl);

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
