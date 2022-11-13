import 'package:cloud_dashboard_client/src/dymamodb/providers/dynamodb_detail_provider.dart';
import 'package:cloud_dashboard_client/src/dymamodb/providers/dynamodb_list_provider.dart';
import 'package:cloud_dashboard_client/src/dymamodb/providers/dynamodb_search_provider.dart';
import 'package:cloud_dashboard_client/src/logger.dart';
import 'package:cloud_dashboard_client/src/widgets/card_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:multi_split_view/multi_split_view.dart';

class DynamoDBScreen extends HookConsumerWidget {
  const DynamoDBScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MultiSplitViewController controller =
        MultiSplitViewController(areas: [Area(weight: 0.2)]);
    final dynamoDBSelect = ref.watch(dynamoDBSelectProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MultiSplitView(
          controller: controller,
          children: [
            const DynamoDBList(),
            dynamoDBSelect != null ? const DynamoDBTable() : Container(),
          ],
        ),
      ),
    );
  }
}

class DynamoDBList extends HookConsumerWidget {
  const DynamoDBList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(dynamoDBListRefreshProvider).when(
        data: (items) => ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return DynamoDBListItem(
                  tableName: items.elementAt(index),
                );
              },
            ),
        error: (Object error, StackTrace? stackTrace) => Container(),
        loading: () => const CupertinoActivityIndicator());
  }
}

class DynamoDBListItem extends HookConsumerWidget {
  final String tableName;

  const DynamoDBListItem({Key? key, required this.tableName}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () {
          ref.read(dynamoDBSelectProvider.state).state = tableName;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(tableName),
        ),
      ),
    );
  }
}

class DynamoDBTable extends HookConsumerWidget {
  const DynamoDBTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("??build first");
    return Column(
      children: [
        const ExpansionTile(
          title: Text("Table Detail"),
          children: [
            DynamoDBTableDescribe(),
          ],
        ),
        const DynamoDBTableSearchCondition(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            DynamoDBItemPaginationPrevButton(),
            DynamoDBItemPaginationNextButton(),
            DynamoDBItemRefreshButton(),
          ],
        ),
        const DynamoDBTableItemList(),
      ],
    );
  }
}

class DynamoDBTableDescribe extends HookConsumerWidget {
  const DynamoDBTableDescribe({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(dynamoDBDetailProvider).when(
          data: (data) => Column(
            children: [
              Text("table tableName"),
              Text(data.table!.tableName ?? ""),
              Text("table keySchema"),
              Text(data.table!.keySchema!.toJson().toString()),
              Text("table tableStatus"),
              Text(data.table!.tableStatus.toString()),
              Text("table creationDateTime"),
              Text(data.table!.creationDateTime.toString()),
              Text("table itemCount"),
              Text(data.table!.itemCount.toString()),
              Text("table size"),
              Text(data.table!.tableSizeBytes.toString()),
              Text("table provisionedThroughput"),
              Text(data.table!.provisionedThroughput!.toString()),
            ],
          ),
          error: (Object error, StackTrace? stackTrace) => const Text("error!"),
          loading: () => const CupertinoActivityIndicator(),
        );
  }
}
// this.creationDateTime,
// this.itemCount,
// this.keySchema,
// this.provisionedThroughput,
// this.tableName,
// this.tableSizeBytes,
// this.tableStatus,

class DynamoDBTableSearchCondition extends HookConsumerWidget {
  const DynamoDBTableSearchCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: const [
            Text("Search Condition"),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search Condition',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: const [
            Text("Search Condition"),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search Condition',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DynamoDBItemPaginationPrevButton extends HookConsumerWidget {
  const DynamoDBItemPaginationPrevButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build

    return CardButton(
      onTap: () {
        // ref.refresh(SQSProviderMapper.detailFutureProvider(queue));
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.arrow_back_ios_new),
      ),
    );
  }
}

class DynamoDBItemPaginationNextButton extends HookConsumerWidget {
  const DynamoDBItemPaginationNextButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build

    return CardButton(
      onTap: () {
        // ref.refresh(SQSProviderMapper.detailFutureProvider(queue));
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

class DynamoDBItemPaginationPageButton extends HookConsumerWidget {
  final int page;

  const DynamoDBItemPaginationPageButton({super.key, required this.page});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build

    return CardButton(
      onTap: () {
        // ref.refresh(SQSProviderMapper.detailFutureProvider(queue));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("$page"),
      ),
    );
  }
}

class DynamoDBItemRefreshButton extends HookConsumerWidget {
  const DynamoDBItemRefreshButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build

    return CardButton(
      onTap: () {
        final queryScan =
            QueryScan(tableName: ref.read(dynamoDBSelectProvider) ?? "");
        ref.refresh(dynamoDBScanProvider(queryScan));
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class DynamoDBTableItemList extends HookConsumerWidget {
  const DynamoDBTableItemList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbName = ref.watch(dynamoDBSelectProvider)!;
    final queryScan = QueryScan(tableName: dbName);
    final dynamoDBSearch = ref.watch(dynamoDBScanProvider(queryScan));
    return dynamoDBSearch.when(
        data: (scanResult) {
          return Expanded(
            child: ListView.builder(
              controller: ScrollController(),
              itemCount: scanResult.items!.length,
              itemBuilder: (context, index) {
                return DynamoDBTableItem(
                  item: scanResult.items!.elementAt(index),
                );
              },
            ),
          );
        },
        error: (Object error, StackTrace? stackTrace) {
          logger.e(error);
          return Container();
        },
        loading: () => const CupertinoActivityIndicator());
  }
}

class DynamoDBTableItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const DynamoDBTableItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardButton(
      onTap: () {
        print(item);
      },
      child: Text(
        item.keys.map((e) => "$e: ${item[e].toJson()}").join("\n"),
        maxLines: 3,
      ),
    );
  }
}
