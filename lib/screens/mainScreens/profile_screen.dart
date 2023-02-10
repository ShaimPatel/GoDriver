import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                top: 34,
                left: 20,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green[100]),
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
                top: MediaQuery.of(context).size.height / 2.3,
                left: MediaQuery.of(context).size.height / 5.8,
                child: const Text(
                  "Shivam Patel",
                  style: TextStyle(
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
                              children: const [
                                Text(
                                  "+91 9616277391",
                                ),
                                Icon(
                                  Icons.call,
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.green[100],
                            endIndent: 10,
                            indent: 10,
                          ),
                          //? Details
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: const [
                                    Icon(
                                      Icons.star,
                                    ),
                                    Text("3.5"),
                                  ],
                                ),

                                //? Total Trips
                                Column(
                                  children: const [
                                    Text("Total Trip"),
                                    Text("100+"),
                                  ],
                                ),
                                //? Experince
                                Column(
                                  children: const [
                                    Text("Earning"),
                                    Text("4K"),
                                  ],
                                ),
                              ],
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
