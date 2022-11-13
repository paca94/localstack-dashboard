import 'package:aws_dynamodb_api/dynamodb-2011-12-05.dart';
import 'package:cloud_dashboard_client/src/dymamodb/providers/dynamodb_service_provider.dart';
import 'package:cloud_dashboard_client/src/profiles/providers/profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dynamoDBSelectProvider = StateProvider<String?>(
  (ref) {
    ref.watch(profileControllerProvider);
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
