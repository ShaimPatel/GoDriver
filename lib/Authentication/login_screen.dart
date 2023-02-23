import 'package:driver_app/Authentication/components/my_button.dart';
import 'package:driver_app/Authentication/components/my_textfield.dart';
import 'package:driver_app/Authentication/signup_screen.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/screens/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Widgets/progess_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//! Initization Section --- :: ---

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

//! Funcation/ Method Section -- :: ---

//todo :: Validation for Feaild ..!
  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
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
      return Fluttertoast.showToast(
        msg: 'Email is not valid // Empty',
        backgroundColor: Colors.black,
        fontSize: 12,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (passwordTextEditingController.text.length < 6) {
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
      return Fluttertoast.showToast(
        msg: 'Password must be atleast 6 charactiers..!',
        backgroundColor: Colors.black,
        fontSize: 12,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      loginDriverNow();
    }
  }

//todo :: Login Driver Now ..!
  loginDriverNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return const ProgressDialogWidget();
        });
    final User? firebaseUser = (await firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error$msg");
      return msg;
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference driverRef =
          FirebaseDatabase.instance.ref().child("drivers");

      driverRef.child(firebaseUser.uid).once().then((driverkey) {
        final snap = driverkey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          if (!mounted) return;
          Fluttertoast.showToast(msg: "Login Successful.");

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext ctx) => const MySplashScreen(),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: "No Record exist with this mail.");

          firebaseAuth.signOut();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext ctx) => const MySplashScreen(),
            ),
          );
        }
      });
    } else {
      if (!mounted) return;
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Error Occured during Login..!");
    }
  }

  //! InitState -- :: --
  @override
  void initState() {
    super.initState();
  }

//! Dispose -- :: --

  @override
  void dispose() {
    super.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
  }

//! UI Section -- :: --

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
