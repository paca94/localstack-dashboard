import 'dart:convert';

import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/models/sqs/create.dart';
import 'package:localstack_dashboard_client/src/providers/sqs/service_provider.dart';
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
    ref.listen(sqsDetailProvider(queueUrl), (previous, next) {
      if (next is AsyncData) {
        ref.read(sqsDetailStateProvider(queueUrl).state).state = next.value!;
      }
    });

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
}
