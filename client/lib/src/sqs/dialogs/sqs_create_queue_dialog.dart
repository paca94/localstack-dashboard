import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstack_dashboard_client/src/sqs/models/sqs_queue_create.dart';

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
