import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_service_provider.dart';

final sqsListRefreshProvider = FutureProvider((ref) async {
  final sqsService = ref.watch(sqsServiceProvider);

  final ListQueuesResult rs = await sqsService.listQueues();
  return rs.queueUrls!.map((e) => ModelSqsQueueInfo(queueUrl: e)).toList();
});

final sqsListProvider = StateProvider((_) {
  return <ModelSqsQueueInfo>[];
});
