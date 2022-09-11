import 'package:aws_sqs_api/sqs-2012-11-05.dart';

class EmptySQS extends SQS {
  EmptySQS() : super(region: "");

  @override
  Future<ListQueuesResult> listQueues({
    int? maxResults,
    String? nextToken,
    String? queueNamePrefix,
  }) async {
    return ListQueuesResult(
      queueUrls: [],
    );
  }
}
