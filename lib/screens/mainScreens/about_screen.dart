import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "About",
        ),
      ),
      body: ListView(
        children: [
          //image
          SizedBox(
            height: 230,
            child: Center(
              child: Image.asset(
                "assets/images/car_logo.png",
                width: 260,
              ),
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.black,
            endIndent: 10,
            indent: 10,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                //company name
                const Text(
                  "Uber & inDriver Clone",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //about you & your company - write some info
                const Text(
                  "This app has been developed by Muhammad Ali, "
                  "This is the world number 1 ride sharing app. Available for all. "
                  "20M+ people already use this app.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Text(
                  "This app has been developed by Muhammad Ali, "
                  "This is the world number 1 ride sharing app. Available for all. "
                  "20M+ people already use this app.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.black,
                  endIndent: 10,
                  indent: 10,
                ),

                const SizedBox(
                  height: 20,
                ),
                //close
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "Close".toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
