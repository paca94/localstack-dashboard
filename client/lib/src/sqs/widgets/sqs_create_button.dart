import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_create.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_service_provider.dart';
import 'package:localstack_dashboard_client/src/utils/dialog_utils.dart';
import 'package:localstack_dashboard_client/src/widgets/card_button.dart';

class SqsCreateButton extends HookConsumerWidget {
  const SqsCreateButton({Key? key}) : super(key: key);

  Future<void> _createQueue(WidgetRef ref, ModelSqsQueueCreate info) async {
    final sqsService = ref.watch(sqsServiceProvider);
    await sqsService.createQueue(
      queueName: info.queueName,
      attributes: {}, //{QueueAttributeName.fifoQueue: info.isFifo.toString()},
    );
    ref.refresh(sqsListRefreshProvider);
  }

  @override
  Widget build(BuildContext context, ref) {
    return CardButton(
      child: const Text('Create Queue'),
      onTap: () async {
        ModelSqsQueueCreate? info = await showSQSCreateQueueDialog(context);
        if (info == null) return;
        await _createQueue(ref, info);
      },
    );
  }
}
