import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:cloud_dashboard_client/src/common/enums.dart';
import 'package:cloud_dashboard_client/src/empty_aws/empty_sqs.dart';
import 'package:cloud_dashboard_client/src/profiles/models/profile.dart';
import 'package:cloud_dashboard_client/src/profiles/providers/profile_provider.dart';
import 'package:cloud_dashboard_client/src/sqs/providers/sqs_service_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sqs_service_provider_test.mocks.dart';

@GenerateMocks([UserProfileController])
void main() {
  late MockUserProfileController mockUserProfileController;

  setUp(() {
    mockUserProfileController = MockUserProfileController();
    mockUserProfileController.addProfile(
        alias: "alias",
        profileType: SupportServiceTypes.aws,
        accessKey: "accessKey",
        secretAccessKey: "secretAccessKey",
        region: "region",
        isSelect: true);
  });

  test("sqs service provider init test", () {
    final container = ProviderContainer(
      overrides: [
        profileControllerProvider.overrideWithValue(mockUserProfileController),
      ],
    );

    when(mockUserProfileController.currentProfile).thenReturn(ModelProfile(
        alias: "alias",
        profileType: SupportServiceTypes.aws,
        accessKey: "accessKey",
        secretAccessKey: "secretAccessKey",
        region: "region",
        isSelect: true));

    expect(container.read(sqsServiceProvider), isA<SQS>());
  });

  test("sqs service provider init test for empty", () {
    final container = ProviderContainer(
      overrides: [
        profileControllerProvider.overrideWithValue(mockUserProfileController),
      ],
    );

    when(mockUserProfileController.currentProfile).thenReturn(ModelProfile(
        alias: "alias",
        profileType: SupportServiceTypes.empty,
        accessKey: "accessKey",
        secretAccessKey: "secretAccessKey",
        region: "region",
        isSelect: true));

    expect(container.read(sqsServiceProvider), isA<EmptySQS>());
  });
}
