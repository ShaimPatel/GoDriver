import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/screens/splash/splash_screen.dart';

import '../../Widgets/progess_dialog.dart';
import '../global/global.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
//! Initilazation Section...****
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

//todo:  For Validatations...
  validateForm() {
    if (nameTextEditingController.text.length < 3) {
      return Fluttertoast.showToast(
        msg: 'Name must be atleast 3 Characters',
        backgroundColor: Colors.white,
        fontSize: 12,
        textColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
    } else if (!emailTextEditingController.text.contains("@")) {
      return Fluttertoast.showToast(
        msg: 'Email is not valid..!',
        backgroundColor: Colors.white,
        fontSize: 12,
        textColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
    } else if (phoneTextEditingController.text.isEmpty) {
      return Fluttertoast.showToast(
        msg: 'Phone number is required..!',
        backgroundColor: Colors.white,
        fontSize: 12,
        textColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
    } else if (phoneTextEditingController.text.length < 12) {
      return Fluttertoast.showToast(
        msg: 'Phone number is not correct..!',
        backgroundColor: Colors.white,
        fontSize: 12,
        textColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
    } else if (passwordTextEditingController.text.length < 6) {
      return Fluttertoast.showToast(
        msg: 'Password must be atleast 6 charactiers..!',
        backgroundColor: Colors.white,
        fontSize: 12,
        textColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
    } else {
      saveUserInfo();
    }
  }

//todo:  Save Drive Infomation..
  saveUserInfo() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return const ProgressDialogWidget(
              message: "Processing , Please wait ..");
        });
    final User? firebaseUser = (await firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error$msg");
    }))
        .user;

    if (firebaseUser != null) {
      Map usersMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "password": passwordTextEditingController.text.trim()
      };

      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child("Users");

      userRef.child(firebaseUser.uid).set(usersMap);
      currentFirebaseUser = firebaseUser;
      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext ctx) => const MySplashScreen()));
    } else {
      if (!mounted) return;
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Account han not been created");
    }
  }

//! UI Section...****
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset("assets/images/logo.png")),
              const SizedBox(height: 10),
              const Text("Register as Driver",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(color: Colors.grey),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Enter Name..!",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              TextField(
                controller: emailTextEditingController,
                style: const TextStyle(color: Colors.grey),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  hintText: "Enter E-mail..!",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              TextField(
                controller: phoneTextEditingController,
                style: const TextStyle(color: Colors.grey),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  hintText: "Enter Phone ..!",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              TextField(
                controller: passwordTextEditingController,
                style: const TextStyle(color: Colors.grey),
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter Password..!",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    validateForm();

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const CarInfoScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                  ),
                  child: const Text("Create Account",
                      style: TextStyle(color: Colors.black54, fontSize: 18))),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: const Text(
                    "Already have an Account? Login Here..!",
                    style: TextStyle(color: Colors.grey),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
