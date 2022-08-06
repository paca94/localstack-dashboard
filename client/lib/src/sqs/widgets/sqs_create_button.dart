import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/create.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/service_provider.dart';
import 'package:localstack_dashboard_client/src/utils/dialog_utils.dart';
import 'package:localstack_dashboard_client/src/widgets/card_button.dart';

class SqsCreateButton extends HookConsumerWidget {
  const SqsCreateButton({Key? key}) : super(key: key);

  Future<void> _createQueue(WidgetRef ref, ModelSqsCreate info) async {
    final sqsService = ref.watch(sqsServiceProvider);
    await sqsService.createQueue(
        queueName: info.queueName,
        attributes: {QueueAttributeName.fifoQueue: "${info.isFifo}"});
    ref.refresh(sqsListRefreshProvider);
  }

  @override
  Widget build(BuildContext context, ref) {
    return CardButton(
      child: const Text('Create Queue'),
      onTap: () async {
        ModelSqsCreate? info = await showSQSCreateQueueDialog(context);
        if (info == null) return;
        await _createQueue(ref, info);
      },
    );
  }
}
