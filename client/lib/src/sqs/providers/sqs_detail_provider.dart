import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_service_provider.dart';

final sqsDetailProvider =
    FutureProvider.family<Map<QueueAttributeName, String>, String>(
        (ref, queueUrl) async {
  final sqsService = ref.watch(sqsServiceProvider);
  final GetQueueAttributesResult rs = await sqsService.getQueueAttributes(
      queueUrl: queueUrl, attributeNames: [QueueAttributeName.all]);
  return rs.attributes!;
});

final sqsDetailStateProvider =
    StateProvider.family<Map<QueueAttributeName, String>, String>(
        (ref, queueUrl) {
  return <QueueAttributeName, String>{};
});
