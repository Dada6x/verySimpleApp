import 'package:firebase/pages/auth/Signup.dart';
import 'package:firebase/pages/home/homePage.dart';
import 'package:firebase/widgets/button.dart';
import 'package:firebase/widgets/my_textFields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    //! SIGNUP LOGIC
    void signUp() async {
      showDialog(
        //loading
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          //login
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Get.off(() =>  Homepage());
      } on FirebaseAuthException catch (e) {
        //! if it gave exception
        Navigator.pop(context);
        Get.snackbar(
          "Login Error",
          e.message ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "      M I N I M A L \n S O C I A L  M E D I A",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 25),
              CustomTextField(
                  hint: "Email",
                  obscureText: false,
                  controller: emailController),
              const SizedBox(height: 25),
              CustomTextField(
                  hint: "Password",
                  obscureText: true,
                  controller: passwordController),
              const Padding(
                padding: EdgeInsets.all(3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("Forget Password ?")],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: customButton("Login", () {
                  signUp();
                }, width, context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Dont You have an Account"),
                  const SizedBox(width: 7),
                  GestureDetector(
                    onTap: () {
                      Get.off(() => const Signup());
                    },
                    child: const Text(
                      "Register Here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
