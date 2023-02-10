// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:users_app/screens/global/global.dart';
import 'package:users_app/screens/mainScreens/profile_screen.dart';
import 'package:users_app/screens/mainScreens/trips_history_screen.dart';

import '../screens/splash/splash_screen.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;

  MyDrawer({
    Key? key,
    this.name,
    this.email,
  }) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.white),
      child: Drawer(
        backgroundColor: const Color.fromARGB(255, 187, 209, 228),
        child: ListView(
          children: [
            //drawer header
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 1,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            color: Colors.blue[100],
                            child: const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.name.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          widget.email.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 6.0,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.white,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(
              height: 6.0,
            ),
            Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  //drawer body
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const TripsHistoryScreen(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.history,
                        color: Colors.blue[200],
                      ),
                      title: const Text(
                        "History",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 40,
                    endIndent: 10,
                    color: Colors.blue[100],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const ProfileScreen(),
                          ));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.blue[200],
                      ),
                      title: const Text(
                        "Visit Profile",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 40,
                    endIndent: 10,
                    color: Colors.blue[100],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Colors.blue[200],
                      ),
                      title: const Text(
                        "About",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 40,
                    endIndent: 10,
                    color: Colors.blue[100],
                  ),
                  GestureDetector(
                    onTap: () {
                      firebaseAuth.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const MySplashScreen()));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.blue[200],
                      ),
                      title: const Text(
                        "Sign Out",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
