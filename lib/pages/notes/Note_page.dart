import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/pages/profile/profile_page.dart';
import 'package:firebase/firebase/firestroe.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // making the FIRESTORESERVICE OBJ
  final FireStoreService fireStoreServiceObj = FireStoreService();

  final TextEditingController _textEditingController = TextEditingController();

  void openNoteBox({String? docID}) {
    //! can done easily with GetX
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _textEditingController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {},
            child: const Text("cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                fireStoreServiceObj.addNotes(_textEditingController.text);
              } else {
                fireStoreServiceObj.updateNote(
                    docID, _textEditingController.text);
              }
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: const Text("N O T E S "),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => ProfilePage());
                },
                icon: const Icon(Icons.person))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: openNoteBox,
          child: const Icon(Icons.add),
        ),
        //! what is StreamBuilder
        body: StreamBuilder<QuerySnapshot>(
          stream: fireStoreServiceObj
              .getNotesStream(), // Connects to Firestore to get live updates.
          builder: (context, snapshot) {
            // snapshot holds data from the stream.
            if (snapshot.hasData)
            //? if we have data get all the docs
            {
              List notesList = snapshot.data!.docs;
              //display as list
              return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    // get each individual doc
                    DocumentSnapshot document = notesList[index];
                    String docID = document.id;
                    // get notes from each doc
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String noteText = data['note'];
                    // display as listTile
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Theme.of(context).colorScheme.secondary,
                        child: ListTile(
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    // Edit
                                    openNoteBox(docID: docID);
                                  },
                                  icon: const Icon(Icons.mode_edit_outlined)),
                              IconButton(
                                  // delete
                                  onPressed: () {
                                    fireStoreServiceObj.deleteNotes(docID);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                          title: Text(noteText),
                        ),
                      ),
                    );
                  });
            } else {
              //? if we dont have data display this
              return const Text("no Notes \n tap the button to add Some!");
            }
          },
        ));
  }
}
