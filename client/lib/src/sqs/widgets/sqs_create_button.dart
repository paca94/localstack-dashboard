import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/sqs/dialogs/sqs_create_queue_dialog.dart';
import 'package:cloud_dashboard_client/src/sqs/models/sqs_queue_create.dart';
import 'package:cloud_dashboard_client/src/sqs/providers/sqs_list_provider.dart';
import 'package:cloud_dashboard_client/src/sqs/providers/sqs_service_provider.dart';
import 'package:cloud_dashboard_client/src/widgets/card_button.dart';

/// use providers
///
/// sqsServiceProvider
///   Purpose to import service to use sqs api
///
/// sqsListRefreshProvider
class SqsCreateButton extends HookConsumerWidget {
  const SqsCreateButton({Key? key}) : super(key: key);

  Future<void> _createQueue(WidgetRef ref, ModelSqsQueueCreate info) async {
    final sqsService = ref.watch(sqsServiceProvider);
    final attributes = <QueueAttributeName, String>{};
    if (info.isFifo) {
      // duplicate check option support required
      attributes[QueueAttributeName.fifoQueue] = "true";
    }
    await sqsService.createQueue(
      queueName: info.queueName,
      attributes: attributes,
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
