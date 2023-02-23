import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Widgets/progess_dialog.dart';
import '../global/global.dart';
import '../screens/splash/splash_screen.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
//! Initization Section -- :: --
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController =
      TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypeList = ['uber-x', 'uber-go', 'bike'];
  String? selectedCarType;

//! Funcation /Method Section ---- :: ----

//todo :: -- Save Car or Vechile Information --
  saveCarInfo() {
    progressBarIndicator();
    Map driverCarInfoMap = {
      "car_color": carColorTextEditingController.text.trim(),
      "car_model": carModelTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "type": selectedCarType,
    };
    DatabaseReference driverRef =
        FirebaseDatabase.instance.ref().child("drivers");

    driverRef
        .child(currentFirebaseUser!.uid)
        .child("car_details")
        .set(driverCarInfoMap);

    Fluttertoast.showToast(msg: "Car Details has been saved . Sucessfully..");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MySplashScreen()));
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

  //todo ::  Validation for feailds -- :: --
  validateForm() {
    if (carModelTextEditingController.text.trim().isEmpty) {
      progressBarIndicator();

      return Fluttertoast.showToast(
        msg: 'Car Model is Empty ...',
        backgroundColor: Colors.black,
        fontSize: 12,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (carNumberTextEditingController.text.trim().isEmpty) {
      progressBarIndicator();

      return Fluttertoast.showToast(
        msg: 'Car Number is Empty ...',
        backgroundColor: Colors.black,
        fontSize: 12,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (carColorTextEditingController.text.trim().isEmpty) {
      progressBarIndicator();

      return Fluttertoast.showToast(
        msg: 'Car color is Empty ...',
        backgroundColor: Colors.black,
        fontSize: 12,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (selectedCarType == null) {
      progressBarIndicator();

      return Fluttertoast.showToast(
        msg: 'Please select car type ...',
        backgroundColor: Colors.black,
        fontSize: 12,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      progressBarIndicator();
      if (carColorTextEditingController.text.isNotEmpty &&
          carModelTextEditingController.text.isNotEmpty &&
          carNumberTextEditingController.text.isNotEmpty &&
          selectedCarType != null) {
        saveCarInfo();
      }
    }
  }

//! UI Section ...****

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          "Car Details",
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
                                "Car Model ",
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
                                controller: carModelTextEditingController,
                                hintText: "Enter your car model ... ",
                                obscureText: false,
                                prefixIcon: const Icon(Icons.pedal_bike),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Car Number ",
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
                                controller: carNumberTextEditingController,
                                hintText: "Enter your car number ... ",
                                obscureText: false,
                                prefixIcon: const Icon(Icons.numbers),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Car Color ",
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
                                controller: carColorTextEditingController,
                                hintText: "Enter your car color ...",
                                obscureText: false,
                                prefixIcon: const Icon(
                                  Icons.color_lens,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Car Type ",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: HexColor("#8d8d8d"),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: HexColor("#f0f3f1"),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: DropdownButtonFormField(
                                      decoration: const InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none)),
                                      elevation: 0,
                                      alignment: Alignment.centerRight,
                                      dropdownColor: Colors.white,
                                      hint: const Text(
                                        "Please choose Car Type",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      value: selectedCarType,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedCarType = newValue;
                                        });
                                      },
                                      items: carTypeList.map((car) {
                                        return DropdownMenuItem(
                                          value: car,
                                          child: Text(car,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                              MyButton(
                                onPressed: () {
                                  validateForm();
                                },
                                buttonText: 'Save Now',
                              ),
                              const SizedBox(
                                height: 12,
                              ),
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
    );
  }
}
