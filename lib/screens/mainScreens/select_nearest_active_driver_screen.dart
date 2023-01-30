// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import 'package:users_app/screens/global/global.dart';

import '../../assistant/assistant_methods.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {
//! Initilazation Section...****
  DatabaseReference? referenceRideRequest;
  SelectNearestActiveDriversScreen({
    Key? key,
    required this.referenceRideRequest,
  }) : super(key: key);

  @override
  State<SelectNearestActiveDriversScreen> createState() =>
      _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState
    extends State<SelectNearestActiveDriversScreen> {
//! Funcation/Method Section....*

  String fareAmount = '';
//todo: Get Fare Amount Accouding To Vehicle Type..!
  getFareAmountAccordingToVehicleType(int index) {
    if (tripdirectionDetailsInfo != null) {
      if (dList[index]["car_details"]["type"].toString() == "bike") {
        fareAmount =
            (AssistantMethods.calculateFareAmountFronOriginToDestination(
                        tripdirectionDetailsInfo!) /
                    2)
                .toStringAsFixed(1);
      }
      if (dList[index]["car_details"]["type"].toString() == "uber-x") {
        fareAmount =
            (AssistantMethods.calculateFareAmountFronOriginToDestination(
                        tripdirectionDetailsInfo!) *
                    2)
                .toStringAsFixed(1);
      }
      if (dList[index]["car_details"]["type"].toString() == "uber-go") {
        fareAmount =
            AssistantMethods.calculateFareAmountFronOriginToDestination(
                    tripdirectionDetailsInfo!)
                .toStringAsFixed(1);
      }
    }
    return fareAmount;
  }

//! UI Section...*****
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        title: const Text("Nearest Online Drivers",
            style: TextStyle(fontSize: 18)),
        leading: IconButton(
          onPressed: () {
            //! Delete the ride request from database..
            widget.referenceRideRequest!.remove();
            Fluttertoast.showToast(msg: "You have canclled the ride request");
            SystemNavigator.pop();
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext ctx, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDriverId = dList[index]["id"].toString();
              });
              Navigator.of(context).pop("DriverSelected");
            },
            child: Card(
              color: Colors.grey,
              elevation: 3,
              shadowColor: Colors.green,
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    "assets/images/${dList[index]["car_details"]["type"]}.png",
                    width: 70,
                  ),
                ),
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${dList[index]["name"]}".toUpperCase(),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Text(
                        dList[index]["car_details"]["car_model"],
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12),
                      ),
                      SmoothStarRating(
                          rating: 3.5,
                          color: Colors.yellow,
                          borderColor: Colors.white,
                          allowHalfRating: true,
                          starCount: 5,
                          size: 15)
                    ]),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tripdirectionDetailsInfo != null
                          ? tripdirectionDetailsInfo!.durationText!
                          : "..",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tripdirectionDetailsInfo != null
                          ? tripdirectionDetailsInfo!.distenceText!
                          : "..",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "₹${getFareAmountAccordingToVehicleType(index)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: dList.length,
      ),
    );
  }
}
