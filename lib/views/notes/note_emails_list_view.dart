import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

typedef EmailCallback = void Function(String email);

class NoteEmailsListView extends StatelessWidget {
  final Iterable<String>? emails;
  final EmailCallback onDeleteEmail;

  const NoteEmailsListView({
    super.key,
    required this.emails,
    required this.onDeleteEmail,
  });

  @override
  Widget build(BuildContext context) {
    return emails == null
        ? Text("You didn't share your note")
        : ListView.builder(
            itemCount: emails!.length,
            itemBuilder: (context, index) {
              final email = emails!.elementAt(index);
              return ListTile(
                title: Text(
                  email,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  onPressed: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete) {
                      onDeleteEmail(email);
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          );
  }
}
