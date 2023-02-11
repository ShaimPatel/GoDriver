import 'package:flutter/material.dart';
import 'package:users_app/screens/global/global.dart';
import 'package:users_app/screens/splash/splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
//todo ::

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(
          seconds: 5,
        ), () {
      CircularProgressIndicator(
        backgroundColor: Colors.black54,
        color: Colors.blue[200],
        strokeWidth: 2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.blue[100],
            child: Stack(children: [
              Image.network(
                "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fG1hbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=1400&q=60",
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 34,
                left: 20,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue[100]),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 25,
                      )),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 4,
                left: MediaQuery.of(context).size.height / 6,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
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
                top: MediaQuery.of(context).size.height / 2.3,
                left: MediaQuery.of(context).size.height / 5.8,
                child: Text(
                  userModelCurrentInfo!.name.toString(),
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
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 1,
                    child: SizedBox(
                      height: 380,
                      width: 400,
                      child: SingleChildScrollView(
                        child: Column(children: [
                          //? Contact
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  "+91 ${userModelCurrentInfo!.phone}",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: const [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "3.5",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),

                                //? Total Trips
                                Column(
                                  children: const [
                                    Text(
                                      "Total Trip",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "100+",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                //? Experince
                                Column(
                                  children: const [
                                    Text(
                                      "Earning",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "4K",
                                      style: TextStyle(
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
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return const ListTile(
                                      title: Text(
                                        "Details",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                  body: const ListTile(
                                    title: Text('''
Uber generated \$17.4 billion revenue in 2021, a 56% increase year-on-year
While Uber primarily made revenue from mobility before the pandemic, in 2021 its delivery business generated more revenue
118 million people use Uber or Uber Eats once a month, a 26% increase year-on-year
Uber drivers completed 6.3 billion trips in 2021, slightly below the 6.9 billion trips completed in 2019 
                                      '''),
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
                                  side: BorderSide(color: Colors.redAccent)),
                            ),
                            onPressed: () {
                              firebaseAuth.signOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => const MySplashScreen()));
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
                ),
              )
            ])));
  }
}
