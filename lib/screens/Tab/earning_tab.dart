// ignore_for_file: library_private_types_in_public_api

import 'package:driver_app/screens/Main/trips_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../InfoHandler/app_info.dart';

class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({Key? key}) : super(key: key);

  @override
  _EarningsTabPageState createState() => _EarningsTabPageState();
}

class _EarningsTabPageState extends State<EarningsTabPage> {
  late String driverTotalEarning;

  @override
  void initState() {
    super.initState();
  }

//! UI Section -- :: --
  @override
  Widget build(BuildContext context) {
    driverTotalEarning =
        Provider.of<AppInfo>(context, listen: false).driverTotalEarnins;
    return Container(
      color: Colors.green[100],
      child: Column(
        children: [
          //earnings
          Container(
            color: Colors.black,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  const Text(
                    "Your Earnings : ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "₹ $driverTotalEarning",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // total number of trips-- :: --
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const TripsHistoryScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/car_logo.png",
                      width: 100,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const Text(
                      "Trips Completed",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Provider.of<AppInfo>(context, listen: false)
                            .allTripsHistoryInformationList
                            .length
                            .toString(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
