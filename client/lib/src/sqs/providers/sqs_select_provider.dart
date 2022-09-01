import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_info.dart';

final sqsSelectProvider = StateProvider<ModelSqsQueueInfo?>((ref) {
  return null;
});
