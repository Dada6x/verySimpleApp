import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: const Text(" U S E R S "),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("UsersInfo").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                //docs
                final allUsers = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      final oneUser = allUsers[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          child: ListTile(
                            leading: const CircleAvatar(),
                            title: Text(oneUser['userName'],
                                style: const TextStyle(color: Colors.black)),
                            subtitle: Text(oneUser['email'],
                                style: const TextStyle(color: Colors.black)),
                          ),
                        ),
                      );
                    });
              }
              return const Text("no Data");
            }));
  }
}
