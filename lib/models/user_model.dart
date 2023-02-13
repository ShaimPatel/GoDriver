//! This Model Is for User Details Information -- :: --

import 'package:firebase_database/firebase_database.dart';

class DriverModel {
  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  String? id;
  String? name;
  String? phone;
  String? email;

  DriverModel.fromSnapshot(DataSnapshot snapshot) {
    name = (snapshot.value as dynamic)["name"];
    id = (snapshot.value as dynamic)["id"];
    email = (snapshot.value as dynamic)["email"];
    phone = (snapshot.value as dynamic)["phone"];
  }
}
