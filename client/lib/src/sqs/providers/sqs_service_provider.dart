import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/empty_aws/empty_sqs.dart';
import 'package:cloud_dashboard_client/src/profiles/providers/profile_provider.dart';

final sqsServiceProvider = Provider((ref) {
  final profileController = ref.watch(profileControllerProvider);
  final currentProfile = profileController.currentProfile;
  if (currentProfile.isEmptyProfile()) {
    return EmptySQS();
  }
  return SQS(
    endpointUrl: currentProfile.endpointUrl,
    region: currentProfile.region,
    credentials: AwsClientCredentials(
        accessKey: currentProfile.accessKey,
        secretKey: currentProfile.secretAccessKey),
  );
});
