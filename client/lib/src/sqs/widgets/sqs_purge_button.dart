import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_service_provider.dart';
import 'package:localstack_dashboard_client/src/widgets/card_button.dart';

class SqsPurgeButton extends HookConsumerWidget {
  final String queueUrl;

  const SqsPurgeButton({Key? key, required this.queueUrl}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardButton(
      onTap: () async {
        final sqsService = ref.watch(sqsServiceProvider);
        await sqsService.purgeQueue(queueUrl: queueUrl);
        ref.refresh(sqsListRefreshProvider);
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Purge"),
      ),
    );
  }
}
