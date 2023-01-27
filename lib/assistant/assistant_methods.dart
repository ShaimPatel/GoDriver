import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/InfoHandler/app_info.dart';
import 'package:users_app/assistant/request_assistant.dart';
import 'package:users_app/models/direction.dart';
import 'package:users_app/models/direction_details_info.dart';
import 'package:users_app/models/user_model.dart';
import 'package:users_app/screens/global/global.dart';
import 'dart:developer' as developer;

import 'package:users_app/screens/global/map_key.dart';

class AssistantMethods {
  //! Funcation for searchAddressForGeographicCordinates..

  static Future<String> searchAddressForGeographicCordinates(
      Position position, context) async {
    String apiURL =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    String humanReadableAddress = '';
    var requestResponse = await RequestAssistant.receiveRequest(apiURL);
    if (requestResponse != "Error Occured, Failed No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];
      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return humanReadableAddress;
  }

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

  //! Start to End Direction details

  static Future<DirectionDetailsInfo?> obtainedOriginToDestinationDetails(
      LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestination =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi =
        await RequestAssistant.receiveRequest(urlOriginToDestination);
    if (responseDirectionApi == "Error Occured, Failed No Response.") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.encodedPoint =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distenceText =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];

    directionDetailsInfo.distanceValue =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.durationText =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];

    directionDetailsInfo.durationValue =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

//todo : Calculate Fare Amount from Origin to Destination
  static double calculateFareAmountFronOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo) {
    double timeTravelrdFareAmountPerMinute =
        (directionDetailsInfo.durationValue! / 60) * 0.1;
    double distanceTravelrdFareAmountPerKiloMeter =
        (directionDetailsInfo.durationValue! / 1000) * 0.1;

    // 1 USD = 80 Rupies
    double totalFareAmount = timeTravelrdFareAmountPerMinute +
        distanceTravelrdFareAmountPerKiloMeter;
    double localCurrancyTotalFare = totalFareAmount * 80;

    return double.parse(localCurrancyTotalFare.toStringAsFixed(1));
  }
}
