import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/profiles/models/profile.dart';

// There is no place to look at the attached queues,
// so when updating information, you need to call refresh.
final sqsAttachServiceProvider =
    StateProvider.family<SQS, ModelProfile>((ref, profile) {
  return SQS(
    endpointUrl: profile.endpointUrl,
    region: profile.region,
    credentials: AwsClientCredentials(
        secretKey: profile.accessKey, accessKey: profile.secretAccessKey),
  );
});
