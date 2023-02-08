// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
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
      backgroundColor: Colors.grey[200],
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
              const Text(
                "Rate Trip Experience",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 22),
              const Divider(
                thickness: 4,
                height: 2,
              ),
              const SizedBox(height: 22),
              SmoothStarRating(
                rating: countRatingstar,
                allowHalfRating: false,
                starCount: 5,
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
