import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_controller_provider.dart';

final sqsAttachListRefreshProvider = FutureProvider((ref) async {
  final sqsAttachController = ref.watch(sqsAttachControllerProvider);
  final List<ModelSqsQueueInfo> queues = sqsAttachController.queues
      .map((e) =>
          ModelSqsQueueInfo(queueUrl: e.queueUrl, isAttach: true, id: e.id))
      .toList();

  return queues;
});

final sqsAttachListProvider = StateProvider((_) {
  return <ModelSqsQueueInfo>[];
});
