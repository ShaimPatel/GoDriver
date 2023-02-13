import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/models/user_ride_request_infomation.dart';
import 'package:driver_app/push_notifications/notification_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationSystem {
//! Initlazation Section -- :: --

  FirebaseMessaging messaging = FirebaseMessaging.instance;

//todo  ::   Initialization Cloud Message -- :: --

  Future initializationCloudMessaging(BuildContext context) async {
    //? Terminated
    //When the device is locked or the application is not running
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //display ride request information - user information for a ride..
        developer.log("This is Ride Request ID :: ");
        print(remoteMessage.data["rideRequestId"]);
        readUserRideRequestInformation(
            remoteMessage.data["rideRequestId"], context);
      }
    });

    //? Foreground
    //When the application is open, in view & in use.
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      //display ride request information - user information for a ride..
      readUserRideRequestInformation(
          remoteMessage!.data["rideRequestId"], context);
    });

    //? Background
    //When the application is open, however in the background (minimised).

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      //display ride request information - user information for a ride..
      readUserRideRequestInformation(
          remoteMessage!.data["rideRequestId"], context);
    });
  }

//todo  ::  Generate And Get Token  -- :: --

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

//todo  ;: Read User Ride Request  Information  -- :: --
  readUserRideRequestInformation(
      String userRideRequestID, BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(userRideRequestID)
        .once()
        .then((snapData) {
      if (snapData.snapshot.value != null) {
        //? Place Sound Notification
        audioPlayer.open(Audio("assets/music/music_notification.mp3"));
        audioPlayer.play();
        double originLatitude = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["latitude"]);
        double originLongitude = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["longitude"]);
        String originAddress =
            (snapData.snapshot.value! as Map)["originAddress"].toString();

        double destinationLatitude = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["latitude"]);
        double destinationLongitude = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["longitude"]);
        String destinationAddress =
            (snapData.snapshot.value! as Map)["destinationAddress"].toString();
        String userName =
            (snapData.snapshot.value! as Map)["userName"].toString();
        String userPhone =
            (snapData.snapshot.value! as Map)["userPhone"].toString();
        String rideRequestID = snapData.snapshot.key!;

        UserRideRequestInformation userRideRequestDetails =
            UserRideRequestInformation();
        userRideRequestDetails.originLatLng =
            LatLng(originLatitude, originLongitude);
        userRideRequestDetails.originAddress = originAddress;
        userRideRequestDetails.destinationLatLng =
            LatLng(destinationLatitude, destinationLongitude);
        userRideRequestDetails.destinationAddress = destinationAddress;

        userRideRequestDetails.userName = userName;
        userRideRequestDetails.userPhone = userPhone;
        userRideRequestDetails.rideRequestId = rideRequestID;

        //? Print Infomation of User..
        developer.log("This is User Ride Request Infomation :: ");
        developer.log(userRideRequestDetails.userName.toString());
        developer.log(userRideRequestDetails.userPhone.toString());
        developer.log(userRideRequestDetails.originAddress.toString());
        developer.log(userRideRequestDetails.destinationLatLng.toString());

        //? Call showDialog
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext ctx) => NotificationDialogBox(
                userRideRequestDetails: userRideRequestDetails));
      } else {
        Fluttertoast.showToast(msg: "This Ride Request ID  do't exixt");
      }
    });
  }
}
