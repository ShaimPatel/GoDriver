import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:users_app/Widgets/my_drawer.dart';
import 'package:users_app/screens/global/global.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  //!
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.8467, 80.9462),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> skey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220;
  double? bottompaddingOfMap = 0.0;

  Position? userCurrantLocation;
  var geoLocator = Geolocator();

  //! LocationPermission
  LocationPermission? _locationPermission;
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
    userCurrantLocation = cPosition;
    LatLng latLngPosition =
        LatLng(userCurrantLocation!.latitude, userCurrantLocation!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14.0);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    _getAddressFromLatLng(cPosition);

    // try {
    //   List<Placemark> placemarks = await placemarkFromCoordinates(
    //       userCurrantLocation!.latitude, userCurrantLocation!.longitude);

    //   developer.log(
    //     "Country =>  ${placemarks.reversed.first.country}"
    //     "  "
    //     "Name => ${placemarks.reversed.first.name}",
    //   );
    //   developer.log(
    //     "locality =>  ${placemarks.reversed.first.locality}"
    //     "  "
    //     "postalCode => ${placemarks.reversed.first.postalCode}",
    //   );
    //   developer.log("street =>  ${placemarks[0].street.toString()}"
    //       "  ");
    //   developer.log(
    //     "subLocality =>  ${placemarks.reversed.first.subLocality}"
    //     "  "
    //     "subThoroughfare => ${placemarks.reversed.first.subThoroughfare}",
    //   );
    //   developer.log("thoroughfare =>  ${placemarks.reversed.first.thoroughfare}"
    //       "  ");
    // } catch (e) {
    //   developer.log(e.toString());
    // }
  }

  //!....
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            userCurrantLocation!.latitude, userCurrantLocation!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];

      print(
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}');
    }).catchError((e) {
      debugPrint(e.toString());
    });
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

  @override
  void initState() {
    super.initState();
    // AssistantMethods.readCurrentOnLineInfo();
    checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: skey,
        drawer: MyDrawer(
          name: userModelCurrentInfo?.name,
          email: userModelCurrentInfo?.email,
        ),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottompaddingOfMap!),
              myLocationEnabled: true,
              mapType: MapType.hybrid,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
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
                    skey.currentState!.openDrawer();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.menu,
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
                                  children: const [
                                    Text(
                                      "From",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    SizedBox(height: 3),
                                    Text("Your Current Location",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
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

                          Row(
                            children: [
                              const Icon(Icons.add_location_alt_outlined,
                                  color: Colors.grey),
                              const SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Where to",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "Your Destination Location",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
}
