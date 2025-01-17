import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final List<String>? emails;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.emails,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
        text = snapshot.data()[textFieldName] as String,
        emails = (snapshot.data()[emailsFieldName] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList();

  CloudNote.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()?['user_id'] as String,
        text = snapshot.data()?['text'] as String,
        emails = (snapshot.data()?['emails'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
}
