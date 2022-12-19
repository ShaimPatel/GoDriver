import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/screens/Authentication/signup_screen.dart';
import 'package:users_app/screens/mainScreens/main_screen.dart';

import '../../Widgets/progess_dialog.dart';
import '../global/global.dart';
import '../splash/splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      return Fluttertoast.showToast(
        msg: 'Email is not valid..!',
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
      loginUserNow();
    }
  }

  //!
  loginUserNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return const ProgressDialogWidget(
              message: "Processing , Please wait ..");
        });
    final User? firebaseUser = (await firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error$msg");
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child("Users");

      userRef.child(firebaseUser.uid).once().then((userKey) {
        final snap = userKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          if (!mounted) return;
          Fluttertoast.showToast(msg: "Login Successful.");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext ctx) => const MainScreen()));
        } else {
          Fluttertoast.showToast(msg: "No Record exist with this mail.");

          firebaseAuth.signOut();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext ctx) => const MySplashScreen()));
        }
      });
    } else {
      if (!mounted) return;
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Error Occured during Login..!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset("assets/images/logo.png")),
              const SizedBox(height: 10),
              const Text("Login as a Driver",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
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
                    "Don't have a Account? Create Here..!",
                    style: TextStyle(color: Colors.grey),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
