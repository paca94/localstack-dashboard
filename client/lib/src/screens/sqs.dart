import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/logger.dart';
import 'package:localstack_dashboard_client/src/profiles/providers/profile_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_attach_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_create_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_queue_list.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_refresh_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_select_info.dart';
import 'package:multi_split_view/multi_split_view.dart';

final logger = getLogger();

class Sqs extends HookConsumerWidget {
  const Sqs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MultiSplitViewController controller =
        MultiSplitViewController(areas: [Area(weight: 0.3)]);
    final profileController = ref.watch(profileControllerProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SqsCreateButton(),
                SqsAttachButton(),
                SqsRefreshButton(),
              ],
            ),
            Expanded(
              child: MultiSplitView(
                controller: controller,
                children: [
                  MultiSplitView(
                    axis: Axis.vertical,
                    children: [
                      if (!profileController.currentProfile.isEmptyProfile())
                        const SqsQueueList(),
                      const SqsQueueList(
                        isAttach: true,
                      ),
                    ],
                  ),
                  const SqsSelectInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
