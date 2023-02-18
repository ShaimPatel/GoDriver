import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../global/global.dart';
import '../splash/splash_screen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
// todo  -- :: ---
  String driverRating = "0.0";
  String driverTotalEarning = "0.0";
  int driverTotalTrip = 0;

//! Funcatin Section  -- :: --

  driverDetails() {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        setState(() {
          driverRating = (snap.snapshot.value as Map)["rating"];
          driverTotalEarning = (snap.snapshot.value as Map)["eraning"];
          driverTotalTrip = (snap.snapshot.value as Map)["tripshistory"].length;
          // print(driverTotalTrip);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    driverDetails();
  }

  //! UI Section    -- :: --
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[100],
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.green[100],
            child: Stack(children: [
              Image.network(
                "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fG1hbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=1400&q=60",
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.25,
                left: MediaQuery.of(context).size.width * 0.30,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(
                      100,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1548449112-96a38a643324?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fG1hbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=1400&q=60",
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.45,
                left: MediaQuery.of(context).size.width * 0.39,
                child: Text(
                  driverData.name.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.40,
                          width: 400,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              //? Contact
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        color: Colors.green,
                                        child: const Icon(
                                          Icons.call,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "+91 ${driverData.phone}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[200],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.blue[100],
                                endIndent: 10,
                                indent: 10,
                              ),
                              //? Details
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          driverRating,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),

                                    //? Total Trips
                                    Column(
                                      children: [
                                        const Text(
                                          "Total Trip",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          driverTotalTrip.toString(),
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    //? Experince
                                    Column(
                                      children: [
                                        const Text(
                                          "Earning",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          driverTotalEarning,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.blue[100],
                                endIndent: 10,
                                indent: 10,
                              ),
                              const SizedBox(height: 10),

                              //? Details
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ExpansionPanelList.radio(
                                  elevation: 1,
                                  animationDuration: kThemeAnimationDuration,
                                  dividerColor: Colors.blue[100],
                                  children: [
                                    ExpansionPanelRadio(
                                      backgroundColor: Colors.white,
                                      headerBuilder: (BuildContext context,
                                          bool isExpanded) {
                                        return const ListTile(
                                          title: Text(
                                            "Steps",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      },
                                      body: Column(
                                        children: const [
                                          ListTile(
                                            title: Text("* Going online"),
                                            subtitle: Text(
                                                "The Driver app is always available. So whenever you’re ready to drive or deliver, open the app and tap GO."),
                                          ),
                                          ListTile(
                                            title: Text(
                                                "* Accepting trip and delivery requests"),
                                            subtitle: Text(
                                                "Once online, you’ll automatically begin to receive requests in your area. Your phone will sound. Swipe to accept."),
                                          ),
                                          ListTile(
                                            title: Text(
                                                "* Turn-by-turn directions"),
                                            subtitle: Text(
                                                "The app makes it easy to find your customer and navigate to their destination."),
                                          ),
                                          ListTile(
                                            title: Text(
                                                "* Earnings with every trip"),
                                            subtitle: Text(
                                                "See how much you’ve made after each trip, and track your progress toward your daily and weekly earnings goals. Earnings automatically transfer to your bank account every week."),
                                          ),
                                          ListTile(
                                            title: Text("* Rating system"),
                                            subtitle: Text(
                                                "Riders and drivers, plus other customers, will be asked to provide feedback on every trip."),
                                          ),
                                        ],
                                      ),
                                      value: "step.title",
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 25),
                              //? Button ::
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  textStyle: const TextStyle(fontSize: 16),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      side:
                                          BorderSide(color: Colors.redAccent)),
                                ),
                                onPressed: () {
                                  firebaseAuth.signOut();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) =>
                                              const MySplashScreen()));
                                },
                                icon: const Icon(
                                  Icons.logout,
                                  size: 22,
                                  color: Colors.redAccent,
                                ),
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "LogOut".toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ])));
  }
}
