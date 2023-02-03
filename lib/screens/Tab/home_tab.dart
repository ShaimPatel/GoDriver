// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:driver_app/assistant/assistant_methods.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/push_notifications/push_notifications_system.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../assistant/black_theme_google_map.dart';
import 'dart:developer' as developer;

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
//! Initilization Section...***

  String statusText = "Now Offline";
  Color buttonsColor = Colors.grey;
  bool isDriverActive = false;

  var geoLocator = Geolocator();
  GoogleMapController? newGoogleMapController;
  LocationPermission? _locationPermission;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(26.8467, 80.9462), zoom: 14.4746);

//! Funcation/Method Section....*

//todo: CheckLoaction Permission
  checkLocationPermission() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else if (_locationPermission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
  }

//todo:LocateUserLocation
  locateDriverLocation() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrantPosition = cPosition;
    LatLng latLngPosition = LatLng(
        driverCurrantPosition!.latitude, driverCurrantPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14.0);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCordinates(
            driverCurrantPosition!, context);
  }

//todo:  Read Current Drivers Infomation..
  readCurrentDriverInfomation() async {
    currentFirebaseUser = firebaseAuth.currentUser;
    await FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .once()
        .then((DatabaseEvent snap) {
      if (snap.snapshot.value != null) {
        driverData.id = (snap.snapshot.value as Map)["id"];
        driverData.email = (snap.snapshot.value as Map)["email"];
        driverData.name = (snap.snapshot.value as Map)["name"];
        driverData.phone = (snap.snapshot.value as Map)["phone"];
        driverData.carColor =
            (snap.snapshot.value as Map)["car_details"]["car_color"];
        driverData.carModel =
            (snap.snapshot.value as Map)["car_details"]["car_model"];
        driverData.carNumber =
            (snap.snapshot.value as Map)["car_details"]["car_number"];

        developer
            .log((snap.snapshot.value as Map)["car_details"]["car_number"]);
        developer.log(driverData.name = (snap.snapshot.value as Map)["name"]);
        developer
            .log((snap.snapshot.value as Map)["car_details"]["car_number"]);
      }
    });

    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializationCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
  }

//todo: ->  For Driver Online or Offline
  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrantPosition = pos;
    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
      currentFirebaseUser!.uid,
      driverCurrantPosition!.latitude,
      driverCurrantPosition!.longitude,
    );
    DatabaseReference databaseref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");
    //? :-> Driver is Active and searching for ride request..
    databaseref.set("idle");
    databaseref.onValue.listen((event) {});
  }

//todo: ->  Update Drivers Location RealTime..
  updateDriversLocationsRealTime() {
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrantPosition = position;
      if (isDriverActive == true) {
        Geofire.setLocation(currentFirebaseUser!.uid,
            driverCurrantPosition!.latitude, driverCurrantPosition!.longitude);
      }
      LatLng latLng = LatLng(
          driverCurrantPosition!.latitude, driverCurrantPosition!.longitude);
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

//todo: ->  Driver Offline

  driverIsOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? reff = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    reff.onDisconnect();
    reff.remove();
    reff = null;
    Future.delayed(const Duration(milliseconds: 2000), () {
      // SystemChannels.platform.invokeMethod("SystemNavigator.pop");
      SystemNavigator.pop();
    });
  }

//! InitState Section...****
  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    readCurrentDriverInfomation();
  }

//! UI Section...*****
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            newGoogleMapController = controller;

            blackThemeGoogleMap(newGoogleMapController);
            locateDriverLocation();
          },
        ),

        //? For Online or Offline..
        statusText != "Now Online"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black,
              )
            : Container(),

        //? Button for ofline and online..
        Positioned(
            top: statusText != "Now Online"
                ? MediaQuery.of(context).size.height * 0.50
                : 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttonsColor,
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26))),
                    onPressed: () {
                      //? Calling The Method..

                      if (isDriverActive != true) {
                        driverIsOnlineNow();
                        updateDriversLocationsRealTime();
                        setState(() {
                          statusText = "Now Online";
                          isDriverActive = true;
                          buttonsColor = Colors.transparent;
                        });
                        // ? Toast
                        Fluttertoast.showToast(msg: "You are online now");
                      } else {
                        driverIsOfflineNow();

                        setState(() {
                          statusText = "Now Offline";
                          isDriverActive = false;
                          buttonsColor = Colors.grey;
                        });
                        Fluttertoast.showToast(msg: "You are Offline now");
                      }
                    },
                    child: statusText != "Now Online"
                        ? Text(
                            statusText,
                            style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : const Icon(
                            Icons.phonelink_ring,
                            color: Colors.white,
                            size: 26,
                          )),
              ],
            )),
      ],
    );
  }
}
