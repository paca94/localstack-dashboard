import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_queue_info.dart';

class SqsQueueList extends HookConsumerWidget {
  const SqsQueueList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sqsList = ref.watch(sqsListProvider);
    return Card(
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: ListView.builder(
          itemCount: sqsList.length,
          itemBuilder: (context, index) {
            final currentUrl = sqsList[index];
            return SqsQueueInfo(queueUrl: currentUrl);
          },
        ),
      ),
    );
  }
}
