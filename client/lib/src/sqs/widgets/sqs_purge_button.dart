import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:cloud_dashboard_client/src/sqs/providers/sqs_service_provider.dart';
import 'package:cloud_dashboard_client/src/sqs/sqs_provider_mapper.dart';
import 'package:cloud_dashboard_client/src/widgets/card_button.dart';

class SqsPurgeButton extends HookConsumerWidget {
  final ModelSqsQueueInfo queue;

  const SqsPurgeButton({Key? key, required this.queue}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardButton(
      onTap: () async {
        final sqsService = ref.watch(sqsServiceProvider);
        await sqsService.purgeQueue(queueUrl: queue.queueUrl);
        ref.refresh(SQSProviderMapper.detailFutureProvider(queue));
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Purge"),
      ),
    );
  }
}
