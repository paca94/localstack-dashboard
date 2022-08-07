import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/create.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_detail_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_service_provider.dart';
import 'package:localstack_dashboard_client/src/utils/dialog_utils.dart';

class SqsSendMessageButton extends HookConsumerWidget {
  final String queueUrl;

  const SqsSendMessageButton({Key? key, required this.queueUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () async {
          final sqsService = ref.watch(sqsServiceProvider);
          final ModelSqsMessageCreate? message =
              await showSQSSendMessageDialog(context);
          if (message == null) return;
          final content = message.isEncodeToBase64
              ? base64.encode(utf8.encode(message.messageContent))
              : message.messageContent;
          await sqsService.sendMessage(
              messageBody: content, queueUrl: queueUrl);

          ref.refresh(sqsDetailProvider(queueUrl));
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("SendMessage"),
        ),
      ),
    );
  }
}
