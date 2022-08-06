import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/providers/list_provider.dart';
import 'package:localstack_dashboard_client/src/widgets/card_button.dart';

class SqsRefreshButton extends HookConsumerWidget {
  const SqsRefreshButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return CardButton(
      child: const Icon(Icons.refresh),
      onTap: () {
        ref.refresh(sqsListRefreshProvider);
      },
    );
  }
}
