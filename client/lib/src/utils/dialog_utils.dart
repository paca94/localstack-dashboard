import 'package:flutter/material.dart';

Future<String?> showTextInputDialog(context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController editingController = TextEditingController();
      return AlertDialog(
        content: TextField(
          controller: editingController,
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
              Navigator.of(context).pop(editingController.text);
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
