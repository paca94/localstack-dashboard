import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_service_provider.dart';

final sqsAttachDetailProvider =
    FutureProvider.family<Map<QueueAttributeName, String>, SqsAttachQueue>(
        (ref, queue) async {
  final sqsService =
      ref.watch(sqsAttachServiceProvider(queue.modelInfo.profile!));
  final GetQueueAttributesResult rs = await sqsService.getQueueAttributes(
      queueUrl: queue.modelInfo.queueUrl,
      attributeNames: [QueueAttributeName.all]);
  return rs.attributes!;
});

final sqsAttachDetailStateProvider =
    StateProvider.family<Map<QueueAttributeName, String>, String>(
        (ref, queueUrl) {
  return <QueueAttributeName, String>{};
});
