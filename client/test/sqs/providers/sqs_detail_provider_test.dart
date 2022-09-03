import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_detail_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_service_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sqs_detail_provider_test.mocks.dart';

@GenerateMocks([SQS])
void main() {
  late MockSQS mockSQS;

  setUp(() {
    mockSQS = MockSQS();
  });

  test("sqsDetailProvider test", () async {
    final container = ProviderContainer(
      overrides: [
        sqsServiceProvider.overrideWithValue(mockSQS),
      ],
    );

    final expectedAttributes = {
      QueueAttributeName.all: "all",
    };

    when(mockSQS.getQueueAttributes(
        queueUrl: "queueUrl",
        attributeNames: [QueueAttributeName.all])).thenAnswer(
      (_) async => GetQueueAttributesResult(attributes: expectedAttributes),
    );

    await container.read(sqsDetailProvider("queueUrl").future);

    expect(container.read(sqsDetailProvider("queueUrl")).asData?.value,
        expectedAttributes);
  });
}
