import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/sqs/providers/sqs_select_provider.dart';
import 'package:cloud_dashboard_client/src/sqs/widgets/sqs_detail.dart';

class SqsSelectInfo extends HookConsumerWidget {
  const SqsSelectInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(sqsSelectProvider);
    if (queue == null) return Container();
    return SqsDetail(queue: queue);
  }
}
