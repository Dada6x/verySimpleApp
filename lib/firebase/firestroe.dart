import 'package:cloud_firestore/cloud_firestore.dart';

//!CRUD
class FireStoreService {
/*
CollectionReference is used to access a Firestore collection (notes in this case).
The notes collection stores all notes in Firestore
*/
//! get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  // Think of a collection as a folder, where each note is a document inside it.

//! Create :
  Future<void> addNotes(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
      //'timestamp': Stores the time it was added.
    });
  }

//! READ :

  Stream<QuerySnapshot> getNotesStream() {
    // QuerySnapshot: Represents the collection of documents retrieved from Firestore.
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
/*
Stream:  A continuous flow of Firestore data.
.snapshots(): Listens for changes and updates StreamBuilder
Whenever a note is added, edited, or deleted, Firestore automatically sends new data to StreamBuilder.
*/
  }

//! update :
  Future<void> updateNote(String docID, String newNote) async {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

//! delete :
  Future<void> deleteNotes(String docID) async {
    return notes.doc(docID).delete();
  }
}
