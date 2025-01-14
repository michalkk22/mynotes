import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';

class NoteEmailListView extends StatefulWidget {
  const NoteEmailListView({
    super.key,
  });

  @override
  State<NoteEmailListView> createState() => _NoteEmailListViewState();
}

class _NoteEmailListViewState extends State<NoteEmailListView> {
  CloudNote? note;

  @override
  Widget build(BuildContext context) {
    note = context.getArgument<CloudNote>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add users to note'),
        actions: [
          IconButton(
            onPressed: () {
              //TODO: add email dialog
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: note!.emails?.length ?? 0,
        itemBuilder: (context, index) {
          final email = note!.emails?.elementAt(index);
          return ListTile(
            title: Text(
              email ?? '',
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  // TODO: implement
                }
              },
              icon: const Icon(Icons.delete),
            ),
          );
        },
      ),
    );
  }
}
