// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'package:firebase_database/firebase_database.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  String? id;
  String? name;
  String? phone;
  String? email;

  UserModel.fromSnapshot(DataSnapshot snapshot) {
    name = (snapshot.value as dynamic)["name"];
    id = (snapshot.value as dynamic)["id"];
    email = (snapshot.value as dynamic)["email"];
    phone = (snapshot.value as dynamic)["phone"];
  }
}

//   factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
//         id: json["id"],
//         name: json["name"],
//         phone: json["phone"],
//         email: json["email"],
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "name": name,
//         "phone": phone,
//         "email": email,
//       };
// }
