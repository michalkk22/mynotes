class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteException extends CloudStorageException {}

class CouldNotGetAllNotesException extends CloudStorageException {}

class CouldNotUpdateNoteExcepion extends CloudStorageException {}

class CouldNotDeleteNoteException extends CloudStorageException {}
