import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:cloud_dashboard_client/src/sqs/providers/sqs_attach_controller_provider.dart';

// There is no place to look at the attached queues,
// so when updating information, you need to call refresh.
final sqsAttachServiceProvider =
    Provider.family<SQS, ModelSqsQueueInfo>((ref, queue) {
  final controller = ref.watch(sqsAttachControllerProvider);
  final queueDetail = controller.getQueue(queue.id!);
  final profile = queueDetail.profile!;
  return SQS(
    endpointUrl: profile.endpointUrl,
    region: profile.region,
    credentials: AwsClientCredentials(
      accessKey: profile.accessKey,
      secretKey: profile.secretAccessKey,
    ),
  );
});
