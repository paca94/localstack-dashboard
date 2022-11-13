import 'package:aws_dynamodb_api/dynamodb-2011-12-05.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dynamodb_service_provider.dart';

class QueryScan {
  final String tableName;
  final Map<String, Condition>? scanFilter;

  QueryScan({required this.tableName, this.scanFilter});

  @override
  int get hashCode => tableName.hashCode;
}

final dynamoDBScanProvider = FutureProvider.family<ScanOutput, QueryScan>(
  (ref, QueryScan queryScan) async {
    print(queryScan.hashCode);
    final dynamoDBService = ref.watch(dynamoDBServiceProvider);
    return await dynamoDBService.scan(
      tableName: queryScan.tableName,
      scanFilter: queryScan.scanFilter,
      limit: 20,
    );
  },
);

class QuerySearch {
  late final String tableName;
  late final AttributeValue hashCondition;
  late final Condition? rangeKeyCondition;
}

final dynamoDBQueryProvider = FutureProvider.family<QueryOutput, QuerySearch>(
  (ref, QuerySearch querySearch) async {
    final dynamoDBService = ref.watch(dynamoDBServiceProvider);
    return await dynamoDBService.query(
      tableName: querySearch.tableName,
      hashKeyValue: querySearch.hashCondition,
      rangeKeyCondition: querySearch.rangeKeyCondition,
      limit: 20,
    );
  },
);
