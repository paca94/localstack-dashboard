import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:cloud_dashboard_client/src/sqs/providers/sqs_select_provider.dart';
import 'package:cloud_dashboard_client/src/sqs/sqs_provider_mapper.dart';
import 'package:cloud_dashboard_client/src/widgets/card_button.dart';

class SqsQueueList extends HookConsumerWidget {
  final bool isAttach;

  const SqsQueueList({Key? key, this.isAttach = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sqsList = ref.watch(SQSProviderMapper.getSqsListProvider(isAttach));

    return Card(
      child: SizedBox(
        width: double.infinity,
        child: sqsList.length == 0
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              Text("Not Exist : ${isAttach ? "Attach" : "Profile"}"),
            ),
          ],
        )
            : ListView.builder(
          shrinkWrap: true,
          controller: ScrollController(),
          itemCount: sqsList.length,
          itemBuilder: (context, index) {
            final ModelSqsQueueInfo queue = sqsList[index];
            return CardButton(
              child: Text(queue.queueUrl),
              onTap: () {
                ref
                    .read(sqsSelectProvider.state)
                    .state = queue;
              },
            );
          },
        ),
      ),
    );
  }
}
