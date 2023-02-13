import 'dart:async';

import 'package:driver_app/Authentication/login_screen.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/screens/Main/main_screen.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
//! Funcation Section -- :: --

  //todo  ::  Start Time -- :: --
  void startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (firebaseAuth.currentUser != null) {
        //! Send  user to home screen..! -- :: --
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const MainScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const LoginScreen()));
      }
    });
  }

  //! InitState -- :: --

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  //! UI Section -- :: --

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo1.png"),
              const SizedBox(height: 25),
              const Text(
                "Go Driver App",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
