import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_queue_provider.dart';
import 'package:localstack_dashboard_client/src/utils/dialog_utils.dart';
import 'package:localstack_dashboard_client/src/widgets/card_button.dart';

class SqsDetachButton extends HookConsumerWidget {
  final SqsAttachQueue queue;

  const SqsDetachButton({Key? key, required this.queue}) : super(key: key);

  Future<void> _detachQueue(WidgetRef ref) async {
    final sqsAttachController = ref.watch(sqsAttachControllerProvider);
    sqsAttachController.detachQueue(queue.modelInfo);
  }

  @override
  Widget build(BuildContext context, ref) {
    return CardButton(
      child: const Icon(Icons.visibility_off),
      onTap: () async {
        bool isDel = await showOkOrFalseDialog(
            context, "detach sqs? ${queue.modelInfo.queueUrl}");
        if (isDel) _detachQueue(ref);
      },
    );
  }
}
