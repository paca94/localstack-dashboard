import 'package:aws_dynamodb_api/dynamodb-2011-12-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/dymamodb/providers/dynamodb_service_provider.dart';

final dynamoDBSelectProvider = StateProvider<String?>(
  (ref) {
    return null;
  },
);

final dynamoDBDetailProvider = FutureProvider<DescribeTableOutput>(
  (ref) async {
    final service = ref.watch(dynamoDBServiceProvider);
    final dynamoDBSelect = ref.watch(dynamoDBSelectProvider);
    return await service.describeTable(tableName: dynamoDBSelect!);
  },
);
