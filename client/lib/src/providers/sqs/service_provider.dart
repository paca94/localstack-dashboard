import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/config.dart';

final sqsServiceProvider = Provider((_) => SQS(
    endpointUrl: "http://${LocalStackConfig.host}:${LocalStackConfig.port}/",
    region: LocalStackConfig.region,
    credentials: AwsClientCredentials(secretKey: 'fake', accessKey: 'fake')));
