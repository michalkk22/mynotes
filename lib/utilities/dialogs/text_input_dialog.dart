import 'package:flutter/material.dart';

Future<String?> showTextInputDialog({
  required BuildContext context,
  required String title,
  String? hint,
}) async {
  final controller = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          enableSuggestions: false,
          autocorrect: false,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}
