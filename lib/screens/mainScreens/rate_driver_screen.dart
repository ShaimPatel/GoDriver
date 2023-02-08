// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:users_app/screens/global/global.dart';

class RateDriverScreen extends StatefulWidget {
  String? assignedDriverId;
  RateDriverScreen({
    Key? key,
    this.assignedDriverId,
  }) : super(key: key);

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Rate Trip Experience",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Divider(
                thickness: 4,
                height: 2,
                indent: 15,
                endIndent: 15,
              ),
              const SizedBox(height: 22),
              SmoothStarRating(
                rating: countRatingstar,
                allowHalfRating: false,
                starCount: 5,
                size: 46,
                color: Colors.green,
                borderColor: Colors.green,
                onRatingChanged: (valueOfStarChoosed) {
                  countRatingstar = valueOfStarChoosed;
                  if (countRatingstar == 1) {
                    setState(() {
                      titleStarRating = "Very Bad";
                    });
                  }
                  if (countRatingstar == 2) {
                    setState(() {
                      titleStarRating = "Bad";
                    });
                  }
                  if (countRatingstar == 3) {
                    setState(() {
                      titleStarRating = "Good";
                    });
                  }
                  if (countRatingstar == 4) {
                    setState(() {
                      titleStarRating = "Best";
                    });
                  }
                  if (countRatingstar == 5) {
                    setState(() {
                      titleStarRating = "Excellent";
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                titleStarRating,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                  onPressed: () {
                    DatabaseReference rateDriverRef = FirebaseDatabase.instance
                        .ref()
                        .child("drivers")
                        .child(widget.assignedDriverId!)
                        .child("rating");
                    rateDriverRef.once().then((snap) {
                      //? ::
                      if (snap.snapshot.value == null) {
                        rateDriverRef.set(countRatingstar.toString());
                        Fluttertoast.showToast(msg: "Please Restart App Now..");
                        SystemNavigator.pop();
                      } else {
                        double pastRatings =
                            double.parse(snap.snapshot.value.toString());
                        double newAvargeRatings =
                            (pastRatings + countRatingstar) / 2;
                        rateDriverRef.set(newAvargeRatings.toString());
                        SystemNavigator.pop();
                      }
                      Fluttertoast.showToast(msg: "Please Restart App Now..");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 75,
                        vertical: 10,
                      )),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
