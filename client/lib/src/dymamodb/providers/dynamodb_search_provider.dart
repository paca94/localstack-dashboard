import 'package:aws_dynamodb_api/dynamodb-2011-12-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/dymamodb/providers/dynamodb_detail_provider.dart';

import 'dynamodb_service_provider.dart';

final dynamoDBSearchProvider = FutureProvider<ScanOutput>(
      (ref) async {
    final tableName = ref.watch(dynamoDBSelectProvider)!;
    final dynamoDBService = ref.watch(dynamoDBServiceProvider);
    return await dynamoDBService.scan(tableName: tableName, limit: 20);
  },
);
