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
  double ratingnumbers = 0;
  @override
  void initState() {
    super.initState();
    getRatingNumber();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  //todo ::
  getRatingNumber() {
    setState(() {
      ratingnumbers = double.parse(Provider.of<AppInfo>(context).driverRatings);
    });
    setUpRatingTitle();
  }

//todo  ::

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
                  "Your Ratings ",
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
                rating: ratingnumbers,
                allowHalfRating: false,
                starCount: 5,
                size: 46,
                color: Colors.green,
                borderColor: Colors.green,
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
