import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialogs/text_input_dialog.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:mynotes/views/notes/note_emails_list_view.dart';

class NoteEmailsView extends StatefulWidget {
  const NoteEmailsView({super.key});

  @override
  State<NoteEmailsView> createState() => _NoteEmailsViewState();
}

class _NoteEmailsViewState extends State<NoteEmailsView> {
  late final FireBaseCloudStorage _notesService;
  CloudNote? _note;

  @override
  void initState() {
    _notesService = FireBaseCloudStorage();
    super.initState();
  }

  Future<CloudNote> _getNote(BuildContext context) {
    if (_note != null) {
      return Future.value(_note);
    }
    _note = context.getArgument<CloudNote>();
    if (_note == null) {
      Navigator.of(context).pop();
    }
    return Future.value(_note);
  }

  @override
  Widget build(BuildContext context) {
    _note = context.getArgument<CloudNote>()!;
    return FutureBuilder(
        future: _getNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Add users to note'),
                  actions: [
                    IconButton(
                      onPressed: () async {
                        var email = await showTextInputDialog(
                          context: context,
                          title: 'Enter user email to share note',
                          hint: 'Enter email here',
                        );
                        if (email != null) {
                          await _notesService.addEmail(
                              documentId: _note!.documentId, email: email);
                        }
                      },
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
                body: StreamBuilder(
                  stream:
                      _notesService.streamEmails(documentId: _note!.documentId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final emails = snapshot.data as Iterable<String>;
                      return NoteEmailsListView(
                        emails: emails,
                        onDeleteEmail: (email) async {
                          await _notesService.deleteEmail(
                              documentId: _note!.documentId, email: email);
                        },
                      );
                    } else {
                      return Text("You didn't share your note");
                    }
                  },
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
