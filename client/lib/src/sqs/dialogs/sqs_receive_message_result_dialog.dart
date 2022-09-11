import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/material.dart';
import 'package:cloud_dashboard_client/src/enums.dart';
import 'package:cloud_dashboard_client/src/utils/short_cut.dart';

Future<SQSReceiveMessageActionEnum?> showSQSReceiveMessageResultDialog(context,
    Future<ReceiveMessageResult> receivedMessage, Function buildChild) async {
  final value = await receivedMessage;
  if (value.messages!.isEmpty) {
    ShortCutUtils.showSnackBar(context, 'There are no messages in the queue');
    return SQSReceiveMessageActionEnum.ignore;
  }
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: buildChild(value),
        actions: [
          Tooltip(
            message: "Change visibility timeout to 0",
            child: TextButton(
              child: const Text("RollBack"),
              onPressed: () {
                Navigator.of(context).pop(SQSReceiveMessageActionEnum.rollback);
              },
            ),
          ),
          Tooltip(
            message: "Do not change visibility timeout",
            child: TextButton(
              child: const Text('Ignore'),
              onPressed: () {
                Navigator.of(context).pop(SQSReceiveMessageActionEnum.ignore);
              },
            ),
          ),
          Tooltip(
            message: "Delete message",
            child: TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(SQSReceiveMessageActionEnum.delete);
              },
            ),
          ),
        ],
      );
    },
  );
}
