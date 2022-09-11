import 'package:aws_dynamodb_api/dynamodb-2011-12-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/profiles/providers/profile_provider.dart';

final dynamoDBServiceProvider = Provider((ref) {
  final profileController = ref.watch(profileControllerProvider);
  final currentProfile = profileController.currentProfile;
  return DynamoDB(
    endpointUrl: currentProfile.endpointUrl,
    region: currentProfile.region,
    credentials: AwsClientCredentials(
        accessKey: currentProfile.accessKey,
        secretKey: currentProfile.secretAccessKey),
  );
});
