import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/logger.dart';
import 'package:cloud_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:cloud_dashboard_client/src/sqs/providers/sqs_list_provider.dart';
import 'package:cloud_dashboard_client/src/sqs/providers/sqs_service_provider.dart';
import 'package:cloud_dashboard_client/src/utils/dialog_utils.dart';
import 'package:cloud_dashboard_client/src/widgets/card_button.dart';
import 'package:shared_aws_api/shared.dart';

class SqsDeleteButton extends HookConsumerWidget {
  final ModelSqsQueueInfo queue;

  const SqsDeleteButton({Key? key, required this.queue}) : super(key: key);

  Future<void> _deleteQueue(WidgetRef ref) async {
    final sqsService = ref.watch(sqsServiceProvider);
    try {
      await sqsService.deleteQueue(queueUrl: queue.queueUrl);
    } catch (e) {
      if (e is GenericAwsException &&
          e.code == 'AWS.SimpleQueueService.NonExistentQueue') {
        logger.e("Queue ${queue.queueUrl} does not exist");
      }
    }
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
