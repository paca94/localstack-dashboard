import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_service_provider.dart';

final sqsAttachDetailProvider =
    FutureProvider.family<Map<QueueAttributeName, String>, ModelSqsQueueInfo>(
        (ref, queue) async {
  final sqsService = ref.read(sqsAttachServiceProvider(queue));

  final GetQueueAttributesResult rs = await sqsService.getQueueAttributes(
    queueUrl: queue.queueUrl,
    attributeNames: [QueueAttributeName.all],
  );
  return rs.attributes!;
});

final sqsAttachDetailStateProvider =
    StateProvider.family<Map<QueueAttributeName, String>, ModelSqsQueueInfo>(
        (ref, queue) {
  return <QueueAttributeName, String>{};
});
