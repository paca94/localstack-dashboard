import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_delete_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_detail.dart';

class SqsQueueInfo extends HookConsumerWidget {
  final ModelSqsQueueInfo queue;

  const SqsQueueInfo({Key? key, required this.queue}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final info = Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              queue.queueUrl,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          SqsDeleteButton(queue: queue),
        ],
      ),
    );
    return ExpansionTile(
      title: info,
      children: [SqsDetail(queue: queue)],
    );
  }
}
