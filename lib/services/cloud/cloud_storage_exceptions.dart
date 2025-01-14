class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteException extends CloudStorageException {}

class CouldNotGetAllNotesException extends CloudStorageException {}

class CouldNotUpdateNoteExcepion extends CloudStorageException {}

class CouldNotDeleteNoteException extends CloudStorageException {}

class CouldNotAddEmailNoteExcepion extends CloudStorageException {}

class CouldNotGetEmailsException extends CloudStorageException {}

class CouldNotDeleteEmailNoteExcepion extends CloudStorageException {}
