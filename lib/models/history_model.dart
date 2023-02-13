// ignore_for_file: public_member_api_docs, sort_constructors_first

//! This Model Is for Trips History  Information -- :: --

import 'package:firebase_database/firebase_database.dart';

class TripHistotyModel {
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? userName;
  String? userPhone;
  TripHistotyModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.fareAmount,
    this.userName,
    this.userPhone,
  });

//todo :: To adding into the Database -- :: --

  TripHistotyModel.fromSnapshot(DataSnapshot dataSnapshot) {
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    userName = (dataSnapshot.value as Map)["userName"];
    userPhone = (dataSnapshot.value as Map)["userPhone"];
  }
}
