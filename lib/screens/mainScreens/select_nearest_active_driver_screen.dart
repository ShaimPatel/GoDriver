import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:users_app/screens/global/global.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {
  const SelectNearestActiveDriversScreen({super.key});

  @override
  State<SelectNearestActiveDriversScreen> createState() =>
      _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState
    extends State<SelectNearestActiveDriversScreen> {
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
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext ctx, int index) {
          return Card(
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
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      dList[index]["car_details"]["car_model"],
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 12),
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
                children: const [
                  Text(
                    "13 km",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "\$ 3",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: dList.length,
      ),
    );
  }
}
