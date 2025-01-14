import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FireBaseCloudStorage {
  static final FireBaseCloudStorage _shared =
      FireBaseCloudStorage._sharedInstance();
  FireBaseCloudStorage._sharedInstance();
  factory FireBaseCloudStorage() => _shared;

  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteExcepion();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Stream<Iterable<String>?> streamEmails({required String documentId}) => notes
      .doc(documentId)
      .snapshots()
      .map((doc) => CloudNote.fromDocumentSnapshot(doc).emails);

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
      emails: null,
    );
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<List<String>?> getEmails({required String documentId}) async {
    print('getEmails.documentId: $documentId');
    try {
      DocumentSnapshot snapshot = await notes.doc(documentId).get();

      if (snapshot.data() != null &&
          (snapshot.data() as Map<String, dynamic>)
              .containsKey(emailsFieldName)) {
        print('Emails found: ${snapshot[emailsFieldName]}');
        return List<String>.from(snapshot[emailsFieldName] as List);
      } else {
        print('Emails field is missing or null.');
        return null;
      }
    } catch (e) {
      print('Error in getEmails: $e');
      throw CouldNotGetEmailsException();
    }
  }

  Future<void> addEmail({
    required String documentId,
    required String email,
  }) async {
    try {
      print('Adding email: $email');
      final emails = await getEmails(documentId: documentId) ?? [];

      if (!emails.contains(email)) {
        emails.add(email);
        await notes.doc(documentId).update({emailsFieldName: emails});
        print('Email added successfully.');
      } else {
        print('Email already exists in the list.');
      }
    } on CouldNotGetEmailsException {
      rethrow;
    } catch (e) {
      print('Error in addEmail: $e');
      throw CouldNotAddEmailNoteExcepion();
    }
  }

  Future<void> deleteEmail({
    required String documentId,
    required String email,
  }) async {
    try {
      final emails = await getEmails(documentId: documentId) ?? [];
      emails.remove(email);
      await notes.doc(documentId).update({emailsFieldName: emails});
    } catch (e) {
      throw CouldNotDeleteEmailNoteExcepion();
    }
  }
}
