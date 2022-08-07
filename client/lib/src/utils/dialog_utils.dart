import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/enums.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_message_create.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_create.dart';
import 'package:localstack_dashboard_client/src/sqs/widgets/sqs_attach_dialog_content.dart';
import 'package:localstack_dashboard_client/src/utils/short_cut.dart';

Future<ModelSqsQueueCreate?> showSQSCreateQueueDialog(context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController editingController = TextEditingController();
      final checkProvider = StateProvider((_) => false);
      return Consumer(
        builder: (context, ref, child) {
          final isFifo = ref.watch(checkProvider);
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editingController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(
                      value: isFifo,
                      onChanged: (value) {
                        ref.read(checkProvider.state).state = value!;
                      },
                    ),
                    const Text("isFifo"),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop(ModelSqsQueueCreate()
                    ..queueName = editingController.text
                    ..isFifo = isFifo);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

Future<ModelSqsMessageCreate?> showSQSSendMessageDialog(context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController editingController = TextEditingController();
      final checkProvider = StateProvider((_) => false);
      return Consumer(
        builder: (context, ref, child) {
          final isEncodeToBase64 = ref.watch(checkProvider);
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Send Message Content"),
                TextField(
                  controller: editingController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(
                      value: isEncodeToBase64,
                      onChanged: (value) {
                        ref.read(checkProvider.state).state = value!;
                      },
                    ),
                    const Text("encodeBase64"),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop(ModelSqsMessageCreate()
                    ..messageContent = editingController.text
                    ..isEncodeToBase64 = isEncodeToBase64);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

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
          TextButton(
            child: const Text('RollBack'),
            onPressed: () {
              Navigator.of(context).pop(SQSReceiveMessageActionEnum.rollback);
            },
          ),
          TextButton(
            child: const Text('Ignore'),
            onPressed: () {
              Navigator.of(context).pop(SQSReceiveMessageActionEnum.ignore);
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop(SQSReceiveMessageActionEnum.delete);
            },
          ),
        ],
      );
    },
  );
}

Future<bool> showOkOrFalseDialog(context, String text) async {
  bool? result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(text),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
  return result ?? false;
}

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
