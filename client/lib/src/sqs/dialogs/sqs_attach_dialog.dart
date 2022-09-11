import 'package:flutter/material.dart';
import 'package:cloud_dashboard_client/src/sqs/widgets/sqs_attach_dialog_content.dart';

Future<bool> showSqsAttachDialog(context) async {
  bool? result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const SqsAttachDialogContent(),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          const SqsAttachDialogOkButton(),
        ],
      );
    },
  );
  return result ?? false;
}
