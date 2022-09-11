import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/logger.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:localstack_dashboard_client/src/sqs/sqs_provider_mapper.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_detail_refresh_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_purge_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_receive_message_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_send_message_button.dart';
import 'package:localstack_dashboard_client/src/utils/short_cut.dart';

final visibleElements = [
  "approximateNumberOfMessages",
  "approximateNumberOfMessagesNotVisible",
  "approximateNumberOfMessagesDelayed",
];

class SqsDetail extends HookConsumerWidget {
  final ModelSqsQueueInfo queue;

  const SqsDetail({Key? key, required this.queue}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(SQSProviderMapper.detailFutureProvider(queue), (previous, next) {
      if (next is AsyncData) {
        ref.read(SQSProviderMapper.detailStateProvider(queue).state).state =
            next.value!;
      }
      if (next is AsyncError) {
        logger.e(next);
        ShortCutUtils.showSnackBar(context,
            '[Attach] Current Profile SQS Request Fail! ${next.error}');
      }
    });
    final info = ref.watch(SQSProviderMapper.detailStateProvider(queue));

    return Card(child: buildDetailInfo(context, ref, info));
  }

  Widget buildDetailInfo(BuildContext context, WidgetRef ref,
      Map<QueueAttributeName, String> sqsDetail) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              title: Text("[${queue.queueName()}] Detail"),
              children: [
                buildAttributeElement("queueUrl", queue.queueUrl),
                ...buildAttributeInfo(sqsDetail, isDefaultShowElements: false)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SqsSendMessageButton(queue: queue),
                SqsReceiveMessageButton(queue: queue),
                SqsPurgeButton(queue: queue),
                SqsDetailRefreshButton(queue: queue),
              ],
            ),
            ...buildAttributeInfo(sqsDetail),
          ],
        ),
      ),
    );
  }

  buildAttributeInfo(Map<QueueAttributeName, String> sqsDetail,
      {bool isDefaultShowElements = true}) {
    return sqsDetail.entries
        .where((element) =>
            visibleElements.contains(element.key.name) == isDefaultShowElements)
        .map(
      (e) {
        return buildAttributeElement(e.key.name, e.value);
      },
    );
  }

  // queue key name list
  // flutter: queueArn
  // flutter: approximateNumberOfMessages
  // flutter: approximateNumberOfMessagesNotVisible
  // flutter: approximateNumberOfMessagesDelayed
  // flutter: createdTimestamp
  // flutter: lastModifiedTimestamp
  // flutter: visibilityTimeout
  // flutter: maximumMessageSize
  // flutter: messageRetentionPeriod
  // flutter: delaySeconds
  // flutter: policy
  // flutter: redriveAllowPolicy
  // flutter: receiveMessageWaitTimeSeconds
  // flutter: sqsManagedSseEnabled
  // flutter: fifoQueue
  // flutter: deduplicationScope
  // flutter: fifoThroughputLimit
  // flutter: contentBasedDeduplication
  buildAttributeElement(String itemKey, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(itemKey),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: Text(value)),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                },
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
