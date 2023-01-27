import 'package:driver_app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as developer;

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

//todo : Initialization Cloud Message

  Future initializationCloudMessaging() async {
    //? Terminated
    //When the device is locked or the application is not running
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //display ride request information - user information for a ride..

      }
    });

    //? Foreground
    //When the application is open, in view & in use.
    FirebaseMessaging.onMessage.listen((event) {
      //display ride request information - user information for a ride..
    });

    //? Background
    //When the application is open, however in the background (minimised).

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      //display ride request information - user information for a ride..
    });
  }

//todo: Generate And Get Token...

  Future generateAndGetToken() async {
    var registrationToken = await messaging.getToken();

    developer.log("FCM Registration Token => $registrationToken");

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}
