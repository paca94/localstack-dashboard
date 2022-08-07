import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_attach_queue_info.dart';

class SqsAttachQueueList extends HookConsumerWidget {
  const SqsAttachQueueList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sqsList = ref.watch(sqsAttachListProvider);
    return Card(
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: ListView.builder(
          itemCount: sqsList.length,
          itemBuilder: (context, index) {
            final attachQueue = sqsList[index];
            return SqsAttachQueueInfo(queue: attachQueue);
          },
        ),
      ),
    );
  }
}
