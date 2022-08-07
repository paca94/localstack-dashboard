import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/attach_queue.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_queue_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_service_provider.dart';

final sqsAttachListRefreshProvider = FutureProvider((ref) async {
  final sqsAttachController = ref.watch(sqsAttachControllerProvider);
  final List<String> queues = [];

  for (final q in sqsAttachController.queues) {
    if (q.profile == null) continue;
    final sqsService = ref.watch(sqsAttachServiceProvider(q.profile!));
    try {
      final GetQueueAttributesResult rs = await sqsService.getQueueAttributes(
          queueUrl: q.queueUrl, attributeNames: [QueueAttributeName.all]);
      if (rs.attributes == null) {
        // queues.add(SqsAttachInvalidQueue(modelInfo: q));
        queues.add("(invalid) ${q.queueUrl}");
      } else {
        // queues.add(SqsAttachValidQueue(modelInfo: q, attributes: rs.attributes!));
        queues.add(q.queueUrl);
      }
    } catch (e) {
      queues.add("(invalid) ${q.queueUrl}");
    }
  }

  return queues;
});

final sqsAttachListProvider = StateProvider((_) {
  return <SqsAttachQueue>[];
});

abstract class SqsAttachQueue {
  final ModelAttachQueue modelInfo;

  SqsAttachQueue({required this.modelInfo});
}

class SqsAttachInvalidQueue extends SqsAttachQueue {
  SqsAttachInvalidQueue({required ModelAttachQueue modelInfo})
      : super(modelInfo: modelInfo);
}

class SqsAttachValidQueue extends SqsAttachQueue {
  final Map<QueueAttributeName, String> attributes;

  SqsAttachValidQueue(
      {required this.attributes, required ModelAttachQueue modelInfo})
      : super(modelInfo: modelInfo);
}
