import 'package:driver_app/screens/Tab/earning_tab.dart';
import 'package:driver_app/screens/Tab/home_tab.dart';
import 'package:driver_app/screens/Tab/profile_tab.dart';
import 'package:driver_app/screens/Tab/ratings_tab.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          const HomeTabPage(),
          const EarningsTabPage(),
          RatingsTabPage(),
          const ProfileTabPage()
        ],
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
    );
  }
}
