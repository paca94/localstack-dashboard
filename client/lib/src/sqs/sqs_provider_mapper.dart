import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_info.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_detail_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_attach_service_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_detail_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_list_provider.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_service_provider.dart';

/// The implementation of the sqs accessible by the profile and
/// the added sqs are slightly different, so I wrote a mapper and used it.
abstract class SQSProviderMapper {
  static FutureProvider detailFutureProvider(ModelSqsQueueInfo queue) {
    if (queue.isAttach) {
      return sqsAttachDetailProvider(queue);
    }
    return sqsDetailProvider(queue.queueUrl);
  }

  static StateProvider detailStateProvider(ModelSqsQueueInfo queue) {
    if (queue.isAttach) {
      return sqsAttachDetailStateProvider(queue);
    }
    return sqsDetailStateProvider(queue.queueUrl);
  }

  static Provider<SQS> getSqsServiceProvider(ModelSqsQueueInfo queue) {
    if (queue.isAttach) {
      return sqsAttachServiceProvider(queue);
    }
    return sqsServiceProvider;
  }

  static StateProvider getSqsListProvider(bool isAttach) {
    if (isAttach) {
      return sqsAttachListProvider;
    }
    return sqsListProvider;
  }
}
