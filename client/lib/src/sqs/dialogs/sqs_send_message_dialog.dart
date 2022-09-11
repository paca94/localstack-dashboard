import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_dashboard_client/src/sqs/models/sqs_message_create.dart';

Future<ModelSqsMessageCreate?> showSQSSendMessageDialog(context,
    {final isFifo = false}) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController editingController = TextEditingController();
      TextEditingController editingMessageGroupIdController =
          TextEditingController();
      final checkProvider = StateProvider((_) => false);
      return Consumer(
        builder: (context, ref, child) {
          final isEncodeToBase64 = ref.watch(checkProvider);
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editingController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Message Content",
                    border: OutlineInputBorder(),
                  ),
                ),
                if (isFifo)
                  const SizedBox(
                    height: 10,
                  ),
                if (isFifo)
                  TextField(
                    controller: editingMessageGroupIdController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      labelText: "Message Group Id",
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
                    ..isEncodeToBase64 = isEncodeToBase64
                    ..messageGroupId =
                        isFifo ? editingMessageGroupIdController.text : null);
                },
              ),
            ],
          );
        },
      );
    },
  );
}
