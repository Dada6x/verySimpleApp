import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/pages/home/homePage.dart';
import 'package:firebase/pages/auth/login.dart';
import 'package:firebase/widgets/button.dart';
import 'package:firebase/widgets/my_textFields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String passwordError = "";

  File? _selectedImage; // Store the picked image file
  String? _imageUrl; // Store the uploaded image URL

  //! Pick Image Function
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  //! Upload Image to Firebase Storage
  // Future<String?> uploadImage(File imageFile) async {
  //   try {
  //     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     Reference ref =
  //         FirebaseStorage.instance.ref().child("profile_images/$fileName.jpg");

  //     UploadTask uploadTask = ref.putFile(imageFile);
  //     TaskSnapshot snapshot = await uploadTask;

  //     return await snapshot.ref.getDownloadURL();
  //   } catch (e) {
  //     print("Image Upload Error: $e");
  //     return null;
  //   }
  // }

  //! Create User Document in Firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("UsersInfo")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'userName': userNameController.text,
        'password': passwordController.text,
        'imageUrl': _imageUrl ?? "", // Store the image URL
      });
    }
  }

  //! Signup Logic
  void signUp() async {
    setState(() {
      passwordError = passwordController.text != confirmPasswordController.text
          ? "Passwords do not match"
          : "";
    });
    if (passwordError.isNotEmpty) return;

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        "Signup Error",
        "Password field Can't Be Empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Create User in Firebase Auth
      UserCredential? userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      //! Upload image if selected
      // if (_selectedImage != null) {
      //   _imageUrl = await uploadImage(_selectedImage!);
      // }

      // Save user details in Firestore
      await createUserDocument(userCredential);

      Navigator.pop(context);
      Get.off(() => Homepage());
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      Get.snackbar(
        "Signup Error",
        e.message ?? "Something went wrong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? const Icon(Icons.camera_alt,
                            size: 40, color: Colors.black54)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomTextField(
                    hint: "Username",
                    obscureText: false,
                    controller: userNameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomTextField(
                    hint: "Email",
                    obscureText: false,
                    controller: emailController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomTextField(
                    hint: "Password",
                    obscureText: true,
                    controller: passwordController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        hint: "Confirm Password",
                        obscureText: true,
                        controller: confirmPasswordController,
                      ),
                      if (passwordError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 10),
                          child: Text(
                            passwordError,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: customButton("Register", signUp, width, context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    const SizedBox(width: 7),
                    GestureDetector(
                      onTap: () => Get.off(() => LoginPage()),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
