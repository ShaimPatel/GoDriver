import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/InfoHandler/app_info.dart';
import 'package:users_app/Widgets/history_design_ui.dart';

class TripsHistoryScreen extends StatefulWidget {
  const TripsHistoryScreen({super.key});

  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}

class _TripsHistoryScreenState extends State<TripsHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
        title: const Text(
          "Trips History",
          style: TextStyle(color: Colors.black),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              color: Colors.white,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: Provider.of<AppInfo>(context, listen: false)
            .allTripsHistoryInformationList
            .length,
        itemBuilder: (context, i) {
          return HistoryDesignUIWedget(
            tripHistotyModel: Provider.of<AppInfo>(context, listen: false)
                .allTripsHistoryInformationList[i],
          );
        },
      ),
    );
  }
}
