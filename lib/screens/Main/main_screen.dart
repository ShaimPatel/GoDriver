import 'package:driver_app/screens/Tab/earning_tab.dart';
import 'package:driver_app/screens/Tab/home_tab.dart';
import 'package:driver_app/screens/Tab/profile_tab.dart';
import 'package:driver_app/screens/Tab/ratings_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../Widgets/progess_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
//! Initlazation Section -- :: --
  TabController? tabController;
  int selectedIndex = 0;

//! Funcation/Method Section  -- :: --

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

//! InitState  -- :: --
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

//! UI Section -- :: --
  @override
  Widget build(BuildContext context) {
    //! On Exit ..
    Future<bool> showExitPopup() async {
      return await showDialog(
            barrierDismissible: false,
            context: context,
            useSafeArea: true,
            barrierColor: Colors.black.withOpacity(0.5),
            builder: (context) => AlertDialog(
              elevation: 0,
              title: Text(
                'Close App',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              content: Text(
                'Do you want to exit an App ?',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              actions: [
                Column(
                  children: [
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                          onPressed: () => Navigator.of(context).pop(false),
                          icon: const Icon(
                            Icons.close,
                            size: 22,
                            color: Colors.redAccent,
                          ),
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "No".toUpperCase(),
                              style: const TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 16),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                side: BorderSide(color: Colors.greenAccent)),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                          icon: const Icon(
                            Icons.done,
                            size: 22,
                            color: Colors.greenAccent,
                          ),
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Yes".toUpperCase(),
                              style: const TextStyle(
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        body: OfflineBuilder(
          debounceDuration: Duration.zero,
          connectivityBuilder: (
            BuildContext ctx,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            if (connectivity == ConnectivityResult.none) {
              return Scaffold(
                backgroundColor: Colors.green[100],
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ProgressDialogWidget(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Center(
                        child: Text(
                          'Please check your internet connection!',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return child;
          },
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              const HomeTabPage(),
              const EarningsTabPage(),
              RatingsTabPage(),
              const ProfileTabPage()
            ],
          ),
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: selectedIndex,
          onTap: onItemClicked,
          curve: Curves.decelerate,
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: Colors.purple,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: const Icon(Icons.credit_card),
              title: const Text("Earnings"),
              selectedColor: Colors.pink,
            ),

            /// Search
            SalomonBottomBarItem(
              icon: const Icon(Icons.star),
              title: const Text("Ratings"),
              selectedColor: Colors.orange,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
