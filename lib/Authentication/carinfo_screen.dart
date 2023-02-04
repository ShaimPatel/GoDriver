import 'package:driver_app/global/global.dart';
import 'package:driver_app/screens/splash/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Widgets/progess_dialog.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController =
      TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypeList = ['uber-x', 'uber-go', 'bike'];
  String? selectedCarType;

  //!
  saveCarInfo() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return const ProgressDialogWidget(
              message: "Processing , Please wait ..");
        });
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

    Fluttertoast.showToast(
        msg: "Car Details has been saved . Congratulation..");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MySplashScreen()));
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
                  child: Image.asset("assets/images/logo1.png")),
              const SizedBox(height: 10),
              const Text("Write Car Details ",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: carModelTextEditingController,
                style: const TextStyle(color: Colors.grey),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Car Model",
                  hintText: "Enter your Car model..!",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              TextField(
                controller: carNumberTextEditingController,
                style: const TextStyle(color: Colors.grey),
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                  labelText: "Car Number",
                  hintText: "Enter your car number..!",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              TextField(
                  controller: carColorTextEditingController,
                  style: const TextStyle(color: Colors.grey),
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Car Color",
                    hintText: "Enter your car color ..!",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  )),
              const SizedBox(height: 20),
              DropdownButton(
                dropdownColor: Colors.white24,
                hint: const Text(
                  "Please choose Car Type",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
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
                    child:
                        Text(car, style: const TextStyle(color: Colors.grey)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (carColorTextEditingController.text.isNotEmpty &&
                      carModelTextEditingController.text.isNotEmpty &&
                      carNumberTextEditingController.text.isNotEmpty &&
                      selectedCarType != null) {
                    saveCarInfo();
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CarInfoScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),
                child: Text(
                  "Save Now".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
