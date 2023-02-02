// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:driver_app/global/global.dart';
import 'package:driver_app/models/user_ride_request_infomation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Widgets/progess_dialog.dart';
import '../../assistant/assistant_methods.dart';
import '../../assistant/black_theme_google_map.dart';

class NewTripScreen extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;

  NewTripScreen({
    Key? key,
    this.userRideRequestDetails,
  }) : super(key: key);

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
//! Initilization Section...***

  String? buttonTile = "Arrived";
  Color? buttonColors = Colors.green;

  Set<Marker> setOfMarker = <Marker>{};
  Set<Circle> setOfCircle = <Circle>{};
  Set<Polyline> setOfPolyline = <Polyline>{};
  List<LatLng> polyLinePositionCordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPadding = 0.0;

  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(26.8467, 80.9462), zoom: 14.4746);
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? newTripGoogleMapController;
//! Funcation /Method Section....*

//todo :  Step :: 1 when driver accept the user ride request
//todo: originLatLng  = driverCurrent Location
//todo : destinationLatLng  = user PickUp Location.
//todo: Step :: 2 Driver already pickedup the user in his/her car
//todo: originLatLng  = UserPickUpLocation Location
//todo : destinationLatLng  = user DropOff Location.
//todo:-> Here are drawPolyLineFromSourceToDistination
  Future<void> drawPolyLineFromDriverCurrentPositionToUserOriginLocation(
      LatLng originLatLng, LatLng destinationLatLng) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) =>
            const ProgressDialogWidget(message: "Please Wait"));

    var directionDetailsInfo =
        await AssistantMethods.obtainedOriginToDestinationDetails(
            originLatLng, destinationLatLng);

    List<PointLatLng> decodedPpointsResultList =
        polylinePoints.decodePolyline(directionDetailsInfo!.encodedPoint!);
    polyLinePositionCordinates.clear();
    if (decodedPpointsResultList.isNotEmpty) {
      for (var pointLatLng in decodedPpointsResultList) {
        polyLinePositionCordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.purpleAccent,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLinePositionCordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      setOfPolyline.add(polyline);
    });

    LatLngBounds latLagBound;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      latLagBound =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      latLagBound = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      latLagBound = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      latLagBound =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }
    newTripGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(latLagBound, 65));

    Marker originMarker = Marker(
        markerId: const MarkerId("originID"),
        position: originLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

    Marker destinationMarker = Marker(
        markerId: const MarkerId("destinationID"),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

    setState(() {
      setOfMarker.add(originMarker);
      setOfMarker.add(destinationMarker);
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
      center: destinationLatLng,
    );
    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

//! UI Section...*****

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //? GoogleMap

          GoogleMap(
              padding: EdgeInsets.only(bottom: mapPadding),
              myLocationEnabled: true,
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              markers: setOfMarker,
              circles: setOfCircle,
              polylines: setOfPolyline,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapPadding = 350;
                });
                _controller.complete(controller);
                newTripGoogleMapController = controller;
                blackThemeGoogleMap(newTripGoogleMapController);

                //?
                var driverCurrentLatLng = LatLng(
                    driverCurrantPosition!.latitude,
                    driverCurrantPosition!.longitude);
                var userPickUpLocation =
                    widget.userRideRequestDetails!.originLatLng;

                drawPolyLineFromDriverCurrentPositionToUserOriginLocation(
                    driverCurrentLatLng, userPickUpLocation!);
              }),

          //? UI

          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white30,
                        blurRadius: 18.0,
                        spreadRadius: 5,
                        offset: Offset(0.6, 0.6)),
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 23, vertical: 20),
                child: Column(
                  children: [
                    //? Duration
                    const Text(
                      "Arrive in : 2 min",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                    const SizedBox(height: 18.0),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.grey,
                    ),

                    const SizedBox(height: 10.0),
                    // ? UserName - Icon
                    Row(
                      children: [
                        Text(
                          widget.userRideRequestDetails!.userName!,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreenAccent,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.phone_android,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 18.0),

                    //? UserPickUp Locatin-icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/origin.png",
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    //? UserDropUp LOcation-icon
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/destination.png",
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 14.0),

                    const Divider(
                      height: 2,
                      indent: 35,
                      thickness: 2,
                      color: Colors.grey,
                    ),

                    const SizedBox(height: 24.0),
                    //? Elevetd Button

                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          textStyle: const TextStyle(fontSize: 16),
                          shape: const StadiumBorder(
                              side: BorderSide(
                            color: Colors.white,
                          )),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.directions_car,
                          size: 25,
                          color: Colors.green,
                        ),
                        label: Text(
                          buttonTile!,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
