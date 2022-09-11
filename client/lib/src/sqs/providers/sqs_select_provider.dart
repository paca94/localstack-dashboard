import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/profiles/providers/profile_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_info.dart';

final sqsSelectProvider = StateProvider<ModelSqsQueueInfo?>((ref) {
  final profileController = ref.watch(profileControllerProvider);
  if (profileController.currentProfile.isEmptyProfile()) {
    return null;
  }
  return null;
});
