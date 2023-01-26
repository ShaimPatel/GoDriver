// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/InfoHandler/app_info.dart';
import 'package:users_app/Widgets/my_drawer.dart';
import 'package:users_app/Widgets/progess_dialog.dart';
import 'package:users_app/assistant/assistant_methods.dart';
import 'package:users_app/assistant/grofire_assistant.dart';
import 'package:users_app/models/active_nearby_avilable_drivers.dart';
import 'package:users_app/screens/global/global.dart';
import 'dart:developer' as developer;

import 'package:users_app/screens/mainScreens/search_places_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  double? bottompaddingOfMap = 0.0;
  var geoLocator = Geolocator();
  GoogleMapController? newGoogleMapController;
  double searchLocationContainerHeight = 220;
  GlobalKey<ScaffoldState> skey = GlobalKey<ScaffoldState>();
  Position? userCurrantPosition;

  List<LatLng> pLineCoOridinatesList = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  String userName = 'Your Name..!';
  String userEmail = 'xyz@gmail.com';
  bool activeNearbyDriverKeysLoded = false;
  bool openNavigationDrawer = true;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.8467, 80.9462),
    zoom: 14.4746,
  );

  //!
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  //! LocationPermission
  LocationPermission? _locationPermission;

  @override
  void initState() {
    super.initState();
    // AssistantMethods.readCurrentOnLineInfo();
    checkLocationPermission();
  }

  //!..
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
          markerId: MarkerId(eachDriver.driverID!),
          position: eachDriverActivePosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          rotation: 360,
        );

        driverMarkerSet.add(marker);
      }
      setState(() {
        markerSet = driverMarkerSet;
      });
    });
  }

  // initilization GeoFire
  initalizationGeoFireListener() {
    Geofire.initialize("activeDrivers");
    Geofire.queryAtLocation(
            userCurrantPosition!.altitude, userCurrantPosition!.longitude, 3)!
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
            displayActiveDriversOnUserApp();
            break;
        }
      }

      setState(() {});
    });
  }

//Permission Checking...
  checkLocationPermission() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else if (_locationPermission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
  }

  //!LocateUserLocation
  locateUserLocation() async {
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
  }

  //! Black Theme Google map
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

  //!...._getAddressFromLatLng
  Future<void> _getAddressFromLatLng(Position position) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: skey,
        drawer: MyDrawer(
          name: userName,
          email: userEmail,
        ),
        body: Stack(
          children: [
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
                      // SystemNavigator.pop();
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
                                            ? "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 30)}.."
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
                                          ? Provider.of<AppInfo>(context)
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
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(fontSize: 16),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Request a ride".toUpperCase(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ));
  }

  //! Here are drawPolyLineFromSourceToDistination
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
        builder: (BuildContext ctx) =>
            const ProgressDialogWidget(message: "Please Wait"));

    var directionDetailsInfo =
        await AssistantMethods.obtainedOriginToDestinationDetails(
            originLatLng, distinationLatLng);
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
}
