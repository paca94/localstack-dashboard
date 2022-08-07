import 'package:aws_sqs_api/sqs-2012-11-05.dart';

class ModelSqsQueueInfo {
  // profile id
  final SQS sqsService;

  // url
  final String queueUrl;

  // type ->  normal / attach
  final bool isAttach;

  // attributes
  final Map<QueueAttributeName, String>? attributes;

  ModelSqsQueueInfo(
      {required this.sqsService,
      required this.queueUrl,
      this.isAttach = false,
      this.attributes});
}
