import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  //current logged in user
  final User? currentUser = FirebaseAuth.instance.currentUser;
// future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("UsersInfo")
        .doc(currentUser!
            .email) //Retrieves the document where the doc ID is the email of the logged-in user.
        .get(); //Fetches the data from Firestore.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text("P R O F I L E "),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          // FutureBuilder: Used to wait for the getUserDetails() future to complete and display the result
          future: getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
              //theres data
            } else if (snapshot.hasData) {
              Map<String, dynamic>? user = snapshot.data!.data();
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.grey[300],
                      ),
                      // Text("email :${user!['email']}"),
                      Text("email :${user?['email']}"),
                      Text("User Name  :${user?['userName']}"),
                      Text("ImageUrl : ${user?['imageUrl']}"),
                    ],
                  ),
                ),
              );
            }
            return const Text("no DATA BITCH");
          }),
    );
  }
}
