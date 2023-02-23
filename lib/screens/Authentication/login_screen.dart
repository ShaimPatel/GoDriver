import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:users_app/screens/Authentication/signup_screen.dart';
import 'package:users_app/screens/mainScreens/main_screen.dart';

import '../../Widgets/progess_dialog.dart';
import '../global/global.dart';
import '../splash/splash_screen.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//? Initilazation Section..

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

//!Funcation..*******

//todo: For Checking Validation Form..
  validateForm() {
    progressBarIndicator();
    if (!emailTextEditingController.text.contains("@")) {
      return Fluttertoast.showToast(
        msg: 'Email is not valid..!',
        backgroundColor: Colors.black,
        fontSize: 12,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (passwordTextEditingController.text.length < 6) {
      progressBarIndicator();
      return Fluttertoast.showToast(
        msg: 'Password must be atleast 6 charactiers..!',
        backgroundColor: Colors.black,
        fontSize: 12,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      loginUserNow();
    }
  }

  //! Widget For Progress Bar
  Future<void> progressBarIndicator() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return const ProgressDialogWidget();
        });
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

//todo: Whenuser Are Login..

  loginUserNow() async {
    progressBarIndicator();
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
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext ctx) => const MainScreen()));
        } else {
          Fluttertoast.showToast(msg: "No Record exist with this mail.");

          firebaseAuth.signOut();
          Navigator.pushReplacement(
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

//! Dispose -- :: --

  @override
  void dispose() {
    super.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
  }
//! UI Section...****

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const SizedBox(height: 10),
  //             Padding(
  //                 padding: const EdgeInsets.all(20),
  //                 child: Image.asset("assets/images/logo.png")),
  //             const SizedBox(height: 10),
  //             const Text("Login as a Driver",
  //                 style: TextStyle(
  //                     fontSize: 26,
  //                     color: Colors.grey,
  //                     fontWeight: FontWeight.bold)),
  //             TextField(
  //               controller: emailTextEditingController,
  //               style: const TextStyle(color: Colors.grey),
  //               keyboardType: TextInputType.emailAddress,
  //               decoration: const InputDecoration(
  //                 labelText: "E-mail",
  //                 hintText: "Enter E-mail..!",
  //                 enabledBorder: UnderlineInputBorder(
  //                     borderSide: BorderSide(color: Colors.grey)),
  //                 focusedBorder: UnderlineInputBorder(
  //                     borderSide: BorderSide(color: Colors.grey)),
  //                 hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
  //                 labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
  //               ),
  //             ),
  //             TextField(
  //               controller: passwordTextEditingController,
  //               style: const TextStyle(color: Colors.grey),
  //               keyboardType: TextInputType.text,
  //               obscureText: true,
  //               decoration: const InputDecoration(
  //                 labelText: "Password",
  //                 hintText: "Enter Password..!",
  //                 enabledBorder: UnderlineInputBorder(
  //                     borderSide: BorderSide(color: Colors.grey)),
  //                 focusedBorder: UnderlineInputBorder(
  //                     borderSide: BorderSide(color: Colors.grey)),
  //                 hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
  //                 labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             ElevatedButton(
  //                 onPressed: () {
  //                   validateForm();
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.lightGreenAccent,
  //                 ),
  //                 child: Text("Login".toUpperCase(),
  //                     style: const TextStyle(
  //                         color: Colors.black54, fontSize: 18))),
  //             const SizedBox(height: 10),
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => const SignUpScreen()));
  //                 },
  //                 child: const Text(
  //                   "Don't have a Account? Create Here..!",
  //                   style: TextStyle(color: Colors.grey),
  //                 ))
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor("#fed8c3"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  // height: 535,
                  height: MediaQuery.of(context).size.height * 0.70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: HexColor("#ffffff"),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Log In",
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: HexColor("#4f4f4f"),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: HexColor("#8d8d8d"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MyTextField(
                                  onChanged: (() {}),
                                  controller: emailTextEditingController,
                                  hintText: "hello@gmail.com",
                                  obscureText: false,
                                  prefixIcon: const Icon(Icons.mail_outline),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Password",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: HexColor("#8d8d8d"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MyTextField(
                                  controller: passwordTextEditingController,
                                  hintText: "**************",
                                  obscureText: true,
                                  prefixIcon: const Icon(Icons.lock_outline),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MyButton(
                                  onPressed: () {
                                    validateForm();
                                  },
                                  buttonText: 'Login',
                                ),

                                Row(
                                  children: [
                                    Text("Don't have an account?",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: HexColor("#8d8d8d"),
                                        )),
                                    TextButton(
                                      child: Text(
                                        "Sign Up",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: HexColor("#44564a"),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (BuildContext ctx) =>
                                                const SignUpScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                //?
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -200),
                  child: Image.asset(
                    'assets/images/logo1.png',
                    scale: 1.5,
                    width: double.infinity,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
