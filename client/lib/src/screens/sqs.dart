import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/providers/sqs/list_provider.dart';
import 'package:localstack_dashboard_client/src/providers/sqs/service_provider.dart';
import 'package:localstack_dashboard_client/src/utils/dialog_utils.dart';
import 'package:localstack_dashboard_client/src/widgets/sqs/sqs_detail.dart';

// final service = SQS(region: 'eu-west-1');
// final sqsServiceProvider = Provider((_) => SQS(
//     endpointUrl: "http://localhost:24566/",
//     region: 'eu-west-1',
//     credentials: AwsClientCredentials(secretKey: 'fake', accessKey: 'fake')));
//
// final sqsListProvider = StateProvider((_) {
//   return <String>[];
// });

final expandableProvider =
    StateProvider((ref) => <String, ExpandableController>{});

class Sqs extends HookConsumerWidget {
  const Sqs({
    Key? key,
  }) : super(key: key);

  Future<void> listQueues(WidgetRef ref) async {
    // final ListQueuesResult rs = await sqsService.listQueues();
    // ref.read(sqsListProvider.state).state = rs.queueUrls!;
    ref.refresh(sqsListRefreshProvider);
  }

  Future<void> deleteQueues(
      WidgetRef ref, SQS sqsService, String queueUrl) async {
    await sqsService.deleteQueue(queueUrl: queueUrl);
    listQueues(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sqsService = ref.watch(sqsServiceProvider);
    final sqsList = ref.watch(sqsListProvider);
    ref.listen(sqsListRefreshProvider, (previous, next) {
      if (next is AsyncData) {
        ref.read(sqsListProvider.state).state = next.value!;
      }
    });

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildCreateQueueButton(context, sqsService, ref),
                buildListQueueButton(ref, sqsService),
              ],
            ),
            buildListQueue(sqsList, ref, sqsService),
          ],
        ),
      ),
    );
  }

  Widget buildListQueue(List<String> sqsList, WidgetRef ref, SQS sqsService) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: ListView.builder(
          itemCount: sqsList.length,
          itemBuilder: (context, index) {
            final currentUrl = sqsList[index];
            return buildQueueInfo(currentUrl, context, ref, sqsService);
          },
        ),
      ),
    );
  }

  Widget buildQueueInfo(
      String currentUrl, BuildContext context, WidgetRef ref, SQS sqsService) {
    // final expandableMap = ref.watch(expandableProvider);
    // ExpandableController expandableController;
    // if (expandableMap[currentUrl] == null) {
    //   expandableController = ExpandableController();
    //   ref.read(expandableProvider.state).state[currentUrl] =
    //       expandableController;
    // } else {
    //   expandableController = expandableMap[currentUrl]!;
    // }

    final info = Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              currentUrl,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          buildDeleteQueueButton(context, ref, sqsService, currentUrl),
        ],
      ),
    );
    return ExpansionTile(
      title: info,
      children: [SqsDetail(queueUrl: currentUrl)],
    );
    // return ExpandableNotifier(
    //   controller: expandableController,
    //   child: Card(
    //     child: Expandable(
    //       collapsed: info,
    //       expanded: Column(
    //         children: [
    //           info,
    //           SqsDetail(
    //             queueUrl: currentUrl,
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  InkWell buildListQueueButton(WidgetRef ref, SQS sqsService) {
    return InkWell(
      child: const Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.refresh),
        ),
      ),
      onTap: () {
        listQueues(ref);
      },
    );
  }

  Widget buildCreateQueueButton(
      BuildContext context, SQS sqsService, WidgetRef ref) {
    return InkWell(
      child: const Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Create Queue'),
        ),
      ),
      onTap: () async {
        String? queueName = await showTextInputDialog(context);
        final isCreate = (queueName ?? "").isNotEmpty;
        if (!isCreate) return;
        await sqsService.createQueue(queueName: queueName!);
        listQueues(ref);
      },
    );
  }

  InkWell buildDeleteQueueButton(
      BuildContext context, WidgetRef ref, SQS sqsService, String queueUrl) {
    return InkWell(
      child: const Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.delete_forever_rounded),
        ),
      ),
      onTap: () async {
        bool isDel = await showOkOrFalseDialog(context, "del sqs? $queueUrl");
        if (isDel) deleteQueues(ref, sqsService, queueUrl);
      },
    );
  }
}

// create
// list
// delete
