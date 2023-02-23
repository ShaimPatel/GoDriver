// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/InfoHandler/app_info.dart';
import 'package:users_app/Widgets/my_drawer.dart';
import 'package:users_app/Widgets/pay_fare_amount_dialog.dart';
import 'package:users_app/Widgets/progess_dialog.dart';
import 'package:users_app/assistant/assistant_methods.dart';
import 'package:users_app/assistant/geofire_assistant.dart';
import 'package:users_app/models/active_nearby_avilable_drivers.dart';
import 'package:users_app/screens/global/global.dart';
import 'package:users_app/screens/mainScreens/rate_driver_screen.dart';
import 'dart:developer' as developer;

import 'package:users_app/screens/mainScreens/search_places_screen.dart';
import 'package:users_app/screens/mainScreens/select_nearest_active_driver_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
//! Initilazation Section...****

  double? bottompaddingOfMap = 0.0;

  var geoLocator = Geolocator();
  double searchLocationContainerHeight = 230;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverIntoContainerHeight = 0;
  String driverRideStatus = "Driver is comming";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  List<LatLng> pLineCoOridinatesList = [];
  List<ActiveNearbyAvilableDrivers> onlineNearbyAvailableDriversList = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  GlobalKey<ScaffoldState> skey = GlobalKey<ScaffoldState>();

  String userName = 'Your Name..!';
  String userEmail = 'xyz@gmail.com';
  bool activeNearbyDriverKeysLoded = false;
  String userRideRequestStatus = "";
  bool openNavigationDrawer = true;
  bool requestPositionInfo = true;

  GoogleMapController? newGoogleMapController;
  BitmapDescriptor? activeNearbyIcon;
  DatabaseReference? referenceRideRequest;
  LocationPermission? _locationPermission;
  Position? userCurrantPosition;

  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(26.8467, 80.9462), zoom: 14.4746);

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

//! InitState Section...****
  @override
  void initState() {
    super.initState();
    // AssistantMethods.readCurrentOnLineInfo();
    checkLocationPermission();
  }

//! Funcation/Method Section....*

  //! Widget For Progress Bar
  Future<void> progressBarIndicator() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return const ProgressDialogWidget();
        });
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

//todo-> .. Here are Display Active drive on User Map Icon..
  displayActiveDriversOnUserApp() {
    setState(() {
      markerSet.clear();
      circleSet.clear();
      Set<Marker> driverMarkerSet = <Marker>{};

      for (ActiveNearbyAvilableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvilableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);
        Marker marker = Marker(
          markerId: MarkerId("Driver${eachDriver.driverID!}"),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driverMarkerSet.add(marker);
      }
      setState(() {
        markerSet = driverMarkerSet;
      });
    });
  }

//todo:-> initilization GeoFire to Upadte Driver Location
  initalizationGeoFireListener() {
    Geofire.initialize("activeDrivers");
    Geofire.queryAtLocation(
            userCurrantPosition!.latitude, userCurrantPosition!.longitude, 10)!
        .listen((map) {
      if (map != null) {
        var callBack = map['callBack'];
        switch (callBack) {
          //Whenever Any Driver become active-online
          case Geofire.onKeyEntered:
            ActiveNearbyAvilableDrivers activeNearbyAvilableDriver =
                ActiveNearbyAvilableDrivers();
            activeNearbyAvilableDriver.locationLatitude = map['latitude'];
            activeNearbyAvilableDriver.locationLongitude = map['longitude'];
            activeNearbyAvilableDriver.driverID = map['key'];
            GeoFireAssistant.activeNearbyAvilableDriversList
                .add(activeNearbyAvilableDriver);
            if (activeNearbyDriverKeysLoded == true) {
              displayActiveDriversOnUserApp();
            }
            break;
          //Whenever any driver become offline..
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUserApp();
            break;
          //whenever driver move
          case Geofire.onKeyMoved:
            ActiveNearbyAvilableDrivers activeNearbyAvilableDriver =
                ActiveNearbyAvilableDrivers();
            activeNearbyAvilableDriver.locationLatitude = map['latitude'];
            activeNearbyAvilableDriver.locationLongitude = map['longitude'];
            activeNearbyAvilableDriver.driverID = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvilableDriver);
            displayActiveDriversOnUserApp();
            break;
          //display those online/active driver on user app..
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoded = true;
            displayActiveDriversOnUserApp();
            break;
        }
      }

      setState(() {});
    });
  }

//todo:-> Permission Checking...
  checkLocationPermission() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else if (_locationPermission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
  }

//todo :-> LocateUserLocation
  locateUserLocation() async {
    progressBarIndicator();
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrantPosition = cPosition;
    LatLng latLngPosition =
        LatLng(userCurrantPosition!.latitude, userCurrantPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14.0);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCordinates(
            userCurrantPosition!, context);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;
    developer.log(humanReadableAddress);

    initalizationGeoFireListener();
    AssistantMethods.readTripKeysForOnlineUsers(context);
  }

//todo: ->  Black Theme Google map
  blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

//todo: -> _getAddressFromLatLng
  Future<void> _getAddressFromLatLng(Position position) async {
    progressBarIndicator();
    await placemarkFromCoordinates(
            userCurrantPosition!.latitude, userCurrantPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];

      print(
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}');
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

//todo:-> Here are drawPolyLineFromSourceToDistination
  Future<void> drawPolyLineFromOriginToDistination() async {
    var originPostion =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var distinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
    var originLatLng = LatLng(
        originPostion!.locationLatitude!, originPostion.locationLongitude!);
    var distinationLatLng = LatLng(distinationPosition!.locationLatitude!,
        distinationPosition.locationLongitude!);

    showDialog(
        context: context,
        builder: (BuildContext ctx) => const ProgressDialogWidget());

    var directionDetailsInfo =
        await AssistantMethods.obtainedOriginToDestinationDetails(
            originLatLng, distinationLatLng);
    setState(() {
      tripdirectionDetailsInfo = directionDetailsInfo;
    });
    Navigator.pop(context);

    //Print Value
    developer.log("These are points");
    developer.log(directionDetailsInfo!.encodedPoint.toString());

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPpointsResultList =
        polylinePoints.decodePolyline(directionDetailsInfo.encodedPoint!);
    pLineCoOridinatesList.clear();
    if (decodedPpointsResultList.isNotEmpty) {
      for (var pointLatLng in decodedPpointsResultList) {
        pLineCoOridinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.red,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoOridinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });

    LatLngBounds latLagBound;
    if (originLatLng.latitude > distinationLatLng.latitude &&
        originLatLng.longitude > distinationLatLng.longitude) {
      latLagBound =
          LatLngBounds(southwest: distinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > distinationLatLng.longitude) {
      latLagBound = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, distinationLatLng.longitude),
        northeast: LatLng(distinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > distinationLatLng.latitude) {
      latLagBound = LatLngBounds(
        southwest: LatLng(distinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, distinationLatLng.longitude),
      );
    } else {
      latLagBound =
          LatLngBounds(southwest: originLatLng, northeast: distinationLatLng);
    }
    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(latLagBound, 65));

    Marker originMarker = Marker(
        markerId: const MarkerId("originID"),
        infoWindow: InfoWindow(
          title: originPostion.locationName,
          snippet: "Origin",
        ),
        position: originLatLng,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow));

    Marker destinationMarker = Marker(
        markerId: const MarkerId("destinationID"),
        infoWindow: InfoWindow(
          title: distinationPosition.locationName,
          snippet: "Destination",
        ),
        position: distinationLatLng,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange));

    setState(() {
      markerSet.add(originMarker);
      markerSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );
    Circle destinationCircle = Circle(
      circleId: const CircleId("distinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: distinationLatLng,
    );
    setState(() {
      circleSet.add(originCircle);
      circleSet.add(destinationCircle);
    });
  }

//todo:->  createActiveDriverIconMarker
  createActiveDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
        context,
        size: const Size(2, 2),
      );
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "assets/images/car.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }

//todo:->  Save Ride Request Infromation ..
  saveRideRequestInformation() async {
    referenceRideRequest = FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .push(); //Push Create a Uniq Ride request..

    var originLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap = {
      //"key" : "value"
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation.locationLongitude.toString(),
    };

    Map destinationLocationMap = {
      //"key" : "value"
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation.locationLongitude.toString(),
    };

    Map userInformationMap = {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverID": "waiting",
    };

    referenceRideRequest!.set(userInformationMap);
    tripRideRequestInfoStreamSubscription =
        referenceRideRequest!.onValue.listen((eventSnap) async {
      if (eventSnap.snapshot.value == null) {
        return;
      }
      if ((eventSnap.snapshot.value as Map)['car_details'] != null) {
        setState(() {
          driverCarDetails = (eventSnap.snapshot.value as Map)['car_details'];
        });
      }
      if ((eventSnap.snapshot.value as Map)['driverPhone'] != null) {
        setState(() {
          driverPhone = (eventSnap.snapshot.value as Map)['driverPhone'];
        });
      }
      if ((eventSnap.snapshot.value as Map)['driverName'] != null) {
        setState(() {
          driverName = (eventSnap.snapshot.value as Map)['driverName'];
        });
      }

      //?
      if ((eventSnap.snapshot.value as Map)['status'] != null) {
        userRideRequestStatus =
            (eventSnap.snapshot.value as Map)['status'].toString();
      }
      if ((eventSnap.snapshot.value as Map)['driverLocation'] != null) {
        double driverCurrentPositionLat = double.parse(
            (eventSnap.snapshot.value as Map)['driverLocation']['latitude']
                .toString());
        double driverCurrentPositionLng = double.parse(
            (eventSnap.snapshot.value as Map)['driverLocation']['longitude']
                .toString());

        LatLng driverCurrentPositionLatLng =
            LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        //? status :: accepted
        if (userRideRequestStatus == "accepted") {
          updateArrivalTimeToUserPickUpLocation(driverCurrentPositionLatLng);
        }
        //? status :: arrived
        if (userRideRequestStatus == "arrived") {
          driverRideStatus = "Driver has Arrived";
        }
        //? status :: ontrip
        if (userRideRequestStatus == "onTrip") {
          updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
        }
        //? status :: ended
        if (userRideRequestStatus == "ended") {
          if ((eventSnap.snapshot.value as Map)['fareAmount'] != null) {
            double fareAmount =
                double.parse((eventSnap.snapshot.value as Map)['fareAmount']);
            var response = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) =>
                  PayFareAmountDialog(fareAmount: fareAmount),
            );
            if (response.toString().contains("cashPayed")) {
              //? ::  user Can Rate To the Driver..
              if ((eventSnap.snapshot.value as Map)['driverID'] != null) {
                var assignedDriverId =
                    (eventSnap.snapshot.value as Map)['driverID'];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) =>
                          RateDriverScreen(assignedDriverId: assignedDriverId),
                    ));
              }

              Fluttertoast.showToast(
                  msg: "Rate Page ",
                  backgroundColor: Colors.green,
                  textColor: Colors.red,
                  gravity: ToastGravity.BOTTOM);
            }
            referenceRideRequest!.onDisconnect();
            tripRideRequestInfoStreamSubscription!.cancel();
          }
        }
      }
    });
    onlineNearbyAvailableDriversList =
        GeoFireAssistant.activeNearbyAvilableDriversList;
    searchNearstOnlineDrivers();
  }

//todo:
  updateArrivalTimeToUserPickUpLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      LatLng userPickUpPosition =
          LatLng(userCurrantPosition!.latitude, userCurrantPosition!.longitude);

      var directionDetailsInfo =
          await AssistantMethods.obtainedOriginToDestinationDetails(
              driverCurrentPositionLatLng, userPickUpPosition);
      if (directionDetailsInfo == null) {
        return;
      }
      setState(() {
        driverRideStatus =
            "Driver id comming :: ${directionDetailsInfo.durationText.toString()}";
      });
      requestPositionInfo = true;
    }
  }

//todo :: Update reaching Time to User Drop off Location
  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;
      var userdropOffLocation =
          Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
      LatLng userDestinationPosition = LatLng(
        userdropOffLocation!.locationLatitude!,
        userdropOffLocation.locationLongitude!,
      );

      var directionDetailsInfo =
          await AssistantMethods.obtainedOriginToDestinationDetails(
              driverCurrentPositionLatLng, userDestinationPosition);
      if (directionDetailsInfo == null) {
        return;
      }
      setState(() {
        driverRideStatus =
            "Going toward Destination :: ${directionDetailsInfo.durationText.toString()}";
      });
      requestPositionInfo = true;
    }
  }

//todo: Search Near Online Drivers..
  searchNearstOnlineDrivers() async {
    //? No Active Driver Then work this
    if (onlineNearbyAvailableDriversList.isEmpty) {
      //Cancle the ride Request..
      referenceRideRequest!.remove();
      setState(() {
        polylineSet.clear();
        markerSet.clear();
        circleSet.clear();
        pLineCoOridinatesList.clear();
        openNavigationDrawer = true;
      });

      Fluttertoast.showToast(msg: "No Online Nearest Driver Avaliable.!");
      return;
    }

    await retriveOnlineDriveInfo(onlineNearbyAvailableDriversList);
    var response = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (c) => SelectNearestActiveDriversScreen(
              referenceRideRequest: referenceRideRequest)),
    );
    if (response == "DriverSelected") {
      FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(selectedDriverId!)
          .once()
          .then((snap) {
        if (snap.snapshot.value != null) {
          //? Send Notification to Specific Driver..
          sendNotificationDriverNow(selectedDriverId!);
        } else {
          //? Flutter Toast
          Fluttertoast.showToast(
              msg: "This driver do not exit , try again Later :: ");
        }
      });
    }
  }

//todo ::
  showWaitingResponseUI() {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverContainerHeight = 220;
    });
  }

//todo:  sendNotificationDriverNow
  sendNotificationDriverNow(String selectedDriverId) {
    //? Assign rideRequest to new RideStatus in drivers Parent node for that specific choosen driver..
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(selectedDriverId)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);

    //?Automate the push notification..

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(selectedDriverId)
        .child("token")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String deviceRegistrationToken = snap.snapshot.value.toString();

        //? Send Notification Here :: Push Notification
        AssistantMethods.sendNotificationToDriverNow(
          deviceRegistrationToken,
          referenceRideRequest!.key!,
          context,
        );
        //todo: Display waiting Response Ui from Driver
        showWaitingResponseUI();

        //todo: Response  From Driver .

        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(selectedDriverId)
            .child("newRideStatus")
            .onValue
            .listen((eventSnapshot) {
          //!Driver can  Cancle The RideRequest :: Push Notification
          //!(newRideReuest == "idle")
          if (eventSnapshot.snapshot.value == "idle") {
            Fluttertoast.showToast(
                msg:
                    "Driver has cancle your request , Please choose another driver.");
            Future.delayed(const Duration(seconds: 2), () {
              Fluttertoast.showToast(msg: "Restaring Your App..");
              SystemNavigator.pop();
            });
          }
          // :: -> Driver accept tge rideRequest ::  Push Notification
          // :: -> (newRideReuest == "accepted")
          if (eventSnapshot.snapshot.value == "accepted") {
            // :: -> Design And Display UI.. assigned Driver Information..
            showUIForAssignedDriverInfo();
          }
        });

        Fluttertoast.showToast(msg: "Notificatin send Successfully.");
      } else {
        Fluttertoast.showToast(msg: "Please Choose another Driver..");
        return;
      }
    });
  }

//todo :: Show UI for Online Driver Info..
  showUIForAssignedDriverInfo() {
    setState(() {
      waitingResponseFromDriverContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDriverIntoContainerHeight = 250;
    });
  }

//todo :: When Driver are Active
  retriveOnlineDriveInfo(List onlineNearestDriversList) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for (var i = 0; i < onlineNearestDriversList.length; i++) {
      await ref
          .child(onlineNearestDriversList[i].driverID.toString())
          .once()
          .then((dataSnapshot) {
        var driverInfoKey = dataSnapshot.snapshot.value;
        dList.add(driverInfoKey);
        developer.log("DriversKey Information$dList");
      });
    }
  }

//! UI Section...*****
  @override
  Widget build(BuildContext context) {
    createActiveDriverIconMarker();
    return Scaffold(
        key: skey,
        drawer: MyDrawer(
          name: userName,
          email: userEmail,
        ),
        body: Stack(
          children: [
            //? Google Map ::
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottompaddingOfMap!),
              myLocationEnabled: true,
              mapType: MapType.hybrid,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              markers: markerSet,
              circles: circleSet,
              polylines: polylineSet,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                newGoogleMapController = controller;

                //todo:  black them
                blackThemeGoogleMap();
                setState(() {
                  bottompaddingOfMap = 230;
                });
                locateUserLocation();
              },
            ),
            //Add a draver button ..
            Positioned(
              left: 22,
              top: 40,
              child: GestureDetector(
                  onTap: () {
                    if (openNavigationDrawer) {
                      skey.currentState!.openDrawer();
                    } else {
                      //Restart the app..!
                      setState(() {
                        pLineCoOridinatesList.clear();
                        polylineSet.clear();
                        circleSet.clear();
                        markerSet.clear();
                        openNavigationDrawer = true;
                      });
                      SystemNavigator.pop();
                      Fluttertoast.showToast(msg: "Restarting App :: ");
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      openNavigationDrawer == true ? Icons.menu : Icons.close,
                      color: Colors.white,
                      size: 25,
                    ),
                  )),
            ),

            //todo: Searching Ui Location..
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSize(
                  curve: Curves.decelerate,
                  duration: const Duration(milliseconds: 120),
                  child: Container(
                    height: searchLocationContainerHeight,
                    decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 18),
                      child: Column(
                        children: [
                          //todo:  from Location..
                          Row(
                            children: [
                              const Icon(Icons.add_location_alt_outlined,
                                  color: Colors.grey),
                              const SizedBox(width: 12.0),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "From",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                        Provider.of<AppInfo>(context)
                                                    .userPickUpLocation !=
                                                null
                                            ? "${(Provider.of<AppInfo>(context, listen: false).userPickUpLocation!.locationName!).substring(0, 30)}.."
                                            : "Not getting Address",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 14))
                                  ])
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Divider(
                            indent: 30,
                            height: 1,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),

                          GestureDetector(
                            onTap: () async {
                              //! Go to seaech place screen
                              var responseFromSearchScreen =
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) =>
                                              const SearchPlacesScreen()));

                              if (responseFromSearchScreen ==
                                  "obtainedDropoff") {
                                //Draw Routes - draw polyline..
                                await drawPolyLineFromOriginToDistination();
                                setState(() {
                                  openNavigationDrawer = false;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.add_location_alt_outlined,
                                    color: Colors.grey),
                                const SizedBox(width: 12.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Where to",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      Provider.of<AppInfo>(context)
                                                  .userDropOffLocation !=
                                              null
                                          ? Provider.of<AppInfo>(context,
                                                  listen: false)
                                              .userDropOffLocation!
                                              .locationName!
                                          : "Your Destination Location",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(
                            indent: 30,
                            height: 1,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(fontSize: 16),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onPressed: () {
                              if (Provider.of<AppInfo>(context, listen: false)
                                      .userDropOffLocation !=
                                  null) {
                                saveRideRequestInformation();
                              } else {
                                progressBarIndicator();
                                Fluttertoast.showToast(
                                    msg:
                                        " Please Select Your Destination  :: ");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                "Request a ride".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))

            //?  Ui  for waiting  response from Driver..
            ,
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: waitingResponseFromDriverContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        'Waiting fro Response from Driver..',
                        duration: const Duration(seconds: 10),
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      ScaleAnimatedText(
                        'Please wait..',
                        duration: const Duration(seconds: 6),
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                            fontSize: 32.0,
                            color: Colors.white,
                            fontFamily: 'Canterbury'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //? :: UI for displaying Driver Informatin..
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: assignedDriverIntoContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //? status of ride ..
                      Center(
                        child: Text(
                          driverRideStatus,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Divider(
                          height: 2, thickness: 2, color: Colors.white54),
                      const SizedBox(height: 14),

                      //? :: Vechile Details ..
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Vechile Details : - ",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            driverCarDetails,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      //? :: Driver Name ..
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Driver Name : - ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            driverName,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(
                        height: 2,
                        thickness: 2,
                        color: Colors.white38,
                      ),
                      const SizedBox(height: 14),

                      //? :: Call Driver Button
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.green,
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.call,
                            size: 22,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Call Driver",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
