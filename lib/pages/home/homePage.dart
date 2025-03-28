import 'package:firebase/database/firestore_database.dart';
import 'package:firebase/pages/notes/Note_page.dart';
import 'package:firebase/pages/profile/all_users_page.dart';
import 'package:firebase/pages/profile/profile_page.dart';
import 'package:firebase/widgets/button.dart';
import 'package:firebase/widgets/my_textFields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Homepage extends StatelessWidget {
  Homepage({super.key});
  TextEditingController messageController = TextEditingController();
  final FireStoreDataBase dataBase = FireStoreDataBase();

  void postMessage() {
    if (messageController.text.isNotEmpty) {
      dataBase.addPost(messageController.text);
    }
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text("H O M E P A G E"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.logout)),
              IconButton(
                  onPressed: () {
                    Get.to(const AllUsersPage());
                  },
                  icon: const Icon(Icons.people_alt)),
              IconButton(
                  onPressed: () {
                    Get.to(const NotePage());
                  },
                  icon: const Icon(Icons.note_sharp)),
              IconButton(
                  onPressed: () {
                    Get.to(() => ProfilePage());
                  },
                  icon: const Icon(Icons.person))
            ],
          )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                  hint: "Say Something ",
                  obscureText: false,
                  controller: messageController),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: customButton("Post", () {
                postMessage();
              }, width, context),
            ),
            const SizedBox(height: 20),
            const Divider(),
            StreamBuilder(
                stream: dataBase.getPostsSteam(),
                builder: (context, snapshot) {
                  final posts = snapshot.data!.docs;
                  //! waiting
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                    //! there is data
                  } else if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          String message = post['PostMessage'];
                          String userEmail = post['UserEmail'];
                          // String timeStamp = post['TimeStamp'];
                          //return the list tile
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.person),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      ),
                                      color: Colors.grey.shade700,
                                      border: Border(
                                          left: BorderSide(
                                        color: Colors.grey.shade700,
                                      )),
                                    ),
                                    child: ListTile(
                                      title: Text(message),
                                      subtitle: Text(
                                        userEmail,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const Center(
                      child: Text("NO POSTS YET POST SOMETHING !"));
                })
          ],
        ),
      ),
    );
  }
}
