import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/utils/dialog_utils.dart';
import 'package:localstack_dashboard_client/src/widgets/card_button.dart';

class SqsAttachButton extends HookConsumerWidget {
  const SqsAttachButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return CardButton(
      child: const Text("Attach Queue"),
      onTap: () async {
        await showSqsAttachDialog(context);
      },
    );
  }
}
