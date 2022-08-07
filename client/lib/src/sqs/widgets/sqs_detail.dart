import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_detail_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_service_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_detail_refresh_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_purge_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_receive_message_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_send_message_button.dart';

class SqsDetail extends HookConsumerWidget {
  final String queueUrl;

  const SqsDetail({Key? key, required this.queueUrl}) : super(key: key);

  refresh(WidgetRef ref) async {
    ref.refresh(sqsDetailProvider(queueUrl));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      ref.listen(sqsDetailProvider(queueUrl), (previous, next) {
        if (next is AsyncData) {
          ref.read(sqsDetailStateProvider(queueUrl).state).state = next.value!;
        }
      });
    } catch (e) {
      print(e);
    }

    final info = ref.watch(sqsDetailStateProvider(queueUrl));

    return buildDetailInfo(context, ref, info);
  }

  Widget buildDetailInfo(BuildContext context, WidgetRef ref,
      Map<QueueAttributeName, String> sqsDetail) {
    final sqsService = ref.watch(sqsServiceProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SqsSendMessageButton(queueUrl: queueUrl),
              SqsReceiveMessageButton(queueUrl: queueUrl),
              SqsPurgeButton(queueUrl: queueUrl),
              const SqsDetailRefreshButton(),
            ],
          ),
          ...sqsDetail.entries.map(
            (e) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key.name),
                  Text(e.value),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
