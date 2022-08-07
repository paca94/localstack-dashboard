import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_attach_detach_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_detail.dart';

class SqsAttachQueueInfo extends HookConsumerWidget {
  final SqsAttachQueue queue;

  const SqsAttachQueueInfo({Key? key, required this.queue}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    bool isInvalid = false;
    if (queue is SqsAttachInvalidQueue) {
      isInvalid = true;
    }
    final info = Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              "${isInvalid ? "(invalid)" : ""}${queue.modelInfo.queueUrl}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          // detach button
          SqsDetachButton(queue: queue),
        ],
      ),
    );
    return ExpansionTile(
      title: info,
      children: [SqsDetail(queueUrl: queue.modelInfo.queueUrl)],
    );
  }
}
