import 'package:driver_app/InfoHandler/app_info.dart';
import 'package:driver_app/assistant/request_assistant.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/global/map_key.dart';
import 'package:driver_app/models/direction.dart';
import 'package:driver_app/models/direction_details_info.dart';
import 'package:driver_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as developer;

import '../models/history_model.dart';

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
      Directions driverPickUpAddress = Directions();
      driverPickUpAddress.locationLatitude = position.latitude;
      driverPickUpAddress.locationLongitude = position.longitude;
      driverPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(driverPickUpAddress);
    }
    return humanReadableAddress;
  }

  static void readCurrentOnLineInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        driverModelCurrentInfo = DriverModel.fromSnapshot(snap.snapshot);
        developer.log("name${driverModelCurrentInfo!.name.toString()}");
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

//todo:  Pause Live Location Updates..!

  static pauseLiveLocationUpdates() {
    streamSubscription.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }
//todo:  Resume Live Location Updates..!

  static resumeLiveLocationUpdates() {
    streamSubscription.resume();
    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrantPosition!.latitude, driverCurrantPosition!.longitude);
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

    if (driverVehicleType == "bike") {
      double resultFareAmount = (localCurrancyTotalFare.truncate()) / 2.0;
      return resultFareAmount;
    } else if (driverVehicleType == "uber-go") {
      return localCurrancyTotalFare.truncate().toDouble();
    } else if (driverVehicleType == "uber-x") {
      double resultFareAmount = (localCurrancyTotalFare.truncate()) * 2.0;
      return resultFareAmount;
    } else {
      return localCurrancyTotalFare.truncate().toDouble();
    }
  }

//todo ::  Trip key  =ride request key..
//?    ::  Retrive trips key for online users..!

  static void readTripKeysForOnlineDrivers(context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .orderByChild("driverID")
        .equalTo(firebaseAuth.currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        Map keysTripId = snap.snapshot.value as Map;

//? count total trips and share it with Prvider.

        int overAlltripsCounter = keysTripId.length;
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsCounter(overAlltripsCounter);

        //? Share trip key with provider..
        List<String> tripskeysList = [];
        keysTripId.forEach((key, value) {
          tripskeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsKeys(tripskeysList);

        //? Retrive All Histrory..
        readTripsHistoryInfromation(context);
      }
    });
  }

//todo ::
  static void readTripsHistoryInfromation(context) {
    var tripAllKeys =
        Provider.of<AppInfo>(context, listen: false).historyTripKeyList;
    for (String eachKey in tripAllKeys) {
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Request")
          .child(eachKey)
          .once()
          .then((snap) {
        var historyTrips = TripHistotyModel.fromSnapshot(snap.snapshot);

        if ((snap.snapshot.value as Map)["status"] == "ended") {
          //? update-add each history to  OverAll History Data
          Provider.of<AppInfo>(context, listen: false)
              .updateOverAllTripsHistoryInformatin(historyTrips);
        }
      });
    }
  }

//todo ::
  static void readDriverEarning(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("eraning")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String eraning = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false)
            .updateDriverTotalEarnings(eraning);
      }
    });
    readTripKeysForOnlineDrivers(context);
  }

//todo :: Rating For Online Drivers

  static void readDriverAvarageRatings(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("rating")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String avarageRating = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false)
            .updateDriverAvarageRating(avarageRating);
      }
    });
  }
}
