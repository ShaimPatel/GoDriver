import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:users_app/screens/Authentication/login_screen.dart';
import 'package:users_app/screens/splash/splash_screen.dart';

import '../../Widgets/progess_dialog.dart';
import '../global/global.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';

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
    progressBarIndicator();
    if (nameTextEditingController.text.length < 3) {
      return Fluttertoast.showToast(
        msg: 'Name must be atleast 3 Characters',
        backgroundColor: Colors.black,
        fontSize: 12,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (!emailTextEditingController.text.contains("@")) {
      progressBarIndicator();

      return Fluttertoast.showToast(
        msg: 'Email is not valid..!',
        backgroundColor: Colors.black,
        fontSize: 12,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (phoneTextEditingController.text.isEmpty) {
      progressBarIndicator();

      return Fluttertoast.showToast(
        msg: 'Phone number is requiwhite..!',
        backgroundColor: Colors.black,
        fontSize: 12,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (phoneTextEditingController.text.length < 12) {
      progressBarIndicator();

      return Fluttertoast.showToast(
        msg: 'Phone number is not correct..!',
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
      saveUserInfo();
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

//todo:  Save Drive Infomation..
  saveUserInfo() async {
    progressBarIndicator();

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
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext ctx) => const MySplashScreen()));
    } else {
      if (!mounted) return;
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Account han not been created");
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    nameTextEditingController.dispose();
    phoneTextEditingController.dispose();
  }

//! UI Section...****

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
                            "Sign Up",
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
                                  "Name",
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
                                  controller: nameTextEditingController,
                                  hintText: "Enter your name ",
                                  obscureText: false,
                                  prefixIcon: const Icon(Icons.person),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Phone",
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
                                  controller: phoneTextEditingController,
                                  hintText: "Phone Number ",
                                  obscureText: false,
                                  prefixIcon: const Icon(Icons.phone),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
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
                                  buttonText: 'Register'.toUpperCase(),
                                ),
                                const SizedBox(
                                  height: 12,
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
                                        "Sign In",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: HexColor("#44564a"),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (BuildContext ctx) =>
                                                const LoginScreen(),
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
