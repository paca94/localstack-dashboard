import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/sqs_list_provider.dart';
import 'package:localstack_dashboard_client/src/widgets/card_button.dart';

class SqsDetailRefreshButton extends HookConsumerWidget {
  const SqsDetailRefreshButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return CardButton(
      onTap: () {
        ref.refresh(sqsListRefreshProvider);
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
