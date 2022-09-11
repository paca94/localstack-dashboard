import 'package:flutter/material.dart';
import 'package:cloud_dashboard_client/src/sqs/dialogs/sqs_attach_dialog.dart';
import 'package:cloud_dashboard_client/src/widgets/card_button.dart';

class SqsAttachButton extends StatelessWidget {
  const SqsAttachButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardButton(
      child: const Text("Attach Queue"),
      onTap: () async {
        await showSqsAttachDialog(context);
      },
    );
  }
}
