import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_service_provider.dart';
import 'package:localstack_dashboard_client/src/utils/dialog_utils.dart';
import 'package:localstack_dashboard_client/src/widgets/card_button.dart';

class SqsDeleteButton extends HookConsumerWidget {
  final ModelSqsQueueInfo queue;

  const SqsDeleteButton({Key? key, required this.queue}) : super(key: key);

  Future<void> _deleteQueue(WidgetRef ref) async {
    final sqsService = ref.watch(sqsServiceProvider);
    await sqsService.deleteQueue(queueUrl: queue.queueUrl);
    ref.refresh(sqsListRefreshProvider);
  }

  @override
  Widget build(BuildContext context, ref) {
    return CardButton(
      child: const Icon(Icons.delete_forever_rounded),
      onTap: () async {
        bool isDel =
            await showOkOrFalseDialog(context, "del sqs? ${queue.queueUrl}");
        if (isDel) _deleteQueue(ref);
      },
    );
  }
}
