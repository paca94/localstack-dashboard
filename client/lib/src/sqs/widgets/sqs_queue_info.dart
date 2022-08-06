import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_delete_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_detail.dart';

class SqsQueueInfo extends HookConsumerWidget {
  final String queueUrl;

  const SqsQueueInfo({Key? key, required this.queueUrl}) : super(key: key);

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
              queueUrl,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          SqsDeleteButton(queueUrl: queueUrl),
        ],
      ),
    );
    return ExpansionTile(
      title: info,
      children: [SqsDetail(queueUrl: queueUrl)],
    );
  }
}
