import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:cloud_dashboard_client/src/sqs/sqs_provider_mapper.dart';
import 'package:cloud_dashboard_client/src/widgets/card_button.dart';

class SqsDetailRefreshButton extends HookConsumerWidget {
  final ModelSqsQueueInfo queue;

  const SqsDetailRefreshButton({Key? key, required this.queue})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return CardButton(
      onTap: () {
        ref.refresh(SQSProviderMapper.detailFutureProvider(queue));
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
