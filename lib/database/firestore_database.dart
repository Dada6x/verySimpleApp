/*
this db fro storing the Posts ppl posts on their Accounts 
its stored in new collection called "Posts"

each post contains
message
user Email
timeStamp

*/

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDataBase {
// the current logged in User
  User? currentUser = FirebaseAuth.instance.currentUser;

// fetch the collection of posts
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');
// post an post
  Future<void> addPost(
    String message,
  ) {
    return posts.add({
      'UserEmail': currentUser!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

// read the posts from the
  Stream<QuerySnapshot> getPostsSteam() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postsStream;
  }
}
