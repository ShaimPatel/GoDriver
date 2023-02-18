// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:driver_app/InfoHandler/app_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../global/global.dart';

class RatingsTabPage extends StatefulWidget {
  String? assignedDriverId;
  RatingsTabPage({
    Key? key,
    this.assignedDriverId,
  }) : super(key: key);

  @override
  State<RatingsTabPage> createState() => _RatingsTabPageState();
}

class _RatingsTabPageState extends State<RatingsTabPage> {
//! Initlazation Section -- :: --
  double ratingnumbers = 0;

//! InitSate -- :: --
  @override
  void initState() {
    super.initState();

    getRatingNumber();
  }

  //todo ::  Get Rating Number  -- :: --
  getRatingNumber() {
    setState(() {
      ratingnumbers = double.parse(
          Provider.of<AppInfo>(context, listen: false).driverAvarageRatings);
    });
    setUpRatingTitle();
  }

//todo  :: Set Up Rating Title -- :: --

  setUpRatingTitle() {
    if (ratingnumbers == 1) {
      setState(() {
        titleStarRating = "Very Bad";
      });
    }
    if (ratingnumbers == 2) {
      setState(() {
        titleStarRating = "Bad";
      });
    }
    if (ratingnumbers == 3) {
      setState(() {
        titleStarRating = "Good";
      });
    }
    if (ratingnumbers == 4) {
      setState(() {
        titleStarRating = "Best";
      });
    }
    if (ratingnumbers == 5) {
      setState(() {
        titleStarRating = "Excellent";
      });
    }
  }

//! UI section -- :: --
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.green[100],
      body: Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          height: 250,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text(
                  "Your Ratings ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const Divider(
                thickness: 4,
                height: 2,
                indent: 15,
                endIndent: 15,
                color: Colors.black54,
              ),
              const SizedBox(height: 22),
              SmoothStarRating(
                rating: ratingnumbers,
                allowHalfRating: false,
                starCount: 5,
                size: 46,
                color: Colors.orangeAccent,
                borderColor: Colors.yellowAccent,
              ),
              const SizedBox(height: 12),
              Text(
                "Yor are a $titleStarRating Driver",
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
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
