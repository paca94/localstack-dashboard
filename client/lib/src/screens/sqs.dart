import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/logger.dart';
import 'package:localstack_dashboard_client/src/profiles/providers/profile_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_attach_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_create_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_queue_list.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_refresh_button.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_select_info.dart';
import 'package:localstack_dashboard_client/src/utils/short_cut.dart';
import 'package:multi_split_view/multi_split_view.dart';

class Sqs extends HookConsumerWidget {
  const Sqs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MultiSplitViewController controller =
        MultiSplitViewController(areas: [Area(weight: 0.3)]);
    final currentProfile = ref.watch(currentProfileProvider);

    ref.listen(sqsListRefreshProvider, (previous, next) {
      if (next is AsyncData) {
        ref.read(sqsListProvider.state).state = next.value!;
      }
      if (next is AsyncError) {
        logger.e(next);

        ref.read(sqsListProvider.state).state = [];
        ShortCutUtils.showSnackBar(
            context, 'Current Profile SQS Request Fail!');
      }
    });

    ref.listen(sqsAttachListRefreshProvider, (previous, next) {
      if (next is AsyncData) {
        ref.read(sqsAttachListProvider.state).state = next.value!;
      }
      if (next is AsyncError) {
        logger.e(next);
        ref.read(sqsAttachListProvider.state).state = [];
        ShortCutUtils.showSnackBar(context,
            '[Attach] Current Profile SQS Request Fail! ${next.error}');
      }
    });
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
                      if (!currentProfile.isEmptyProfile())
                        const SqsQueueList(
                          isAttach: false,
                        ),
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
