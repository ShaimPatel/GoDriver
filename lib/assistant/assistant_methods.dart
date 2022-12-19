import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:users_app/models/user_model.dart';
import 'package:users_app/screens/global/global.dart';
import 'dart:developer' as developer;

class AssistantMethods {
  static void readCurrentOnLineInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
        developer.log("name${userModelCurrentInfo!.name.toString()}");
      }
    });
  }
}
