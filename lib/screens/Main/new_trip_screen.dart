// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';

import 'package:driver_app/Widgets/fare_amount_collection_dialog.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/models/user_ride_request_infomation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
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
  Position? onlineDriverCurrentPosition;
  Set<Marker> setOfMarker = <Marker>{};
  Set<Circle> setOfCircle = <Circle>{};
  Set<Polyline> setOfPolyline = <Polyline>{};
  List<LatLng> polyLinePositionCordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPadding = 0.0;
  String rideRequestStatus = "accepted";
  String durationFromOriginToDestination = "";
  bool isRequestDirectinDetails = false;

  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();

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
  Future<void> drawPolyLineFromOriginToDestination(
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

//todo:  Save Assign Driver Details to user Ride Request..!

  saveAssigenDriverDetailsUserRiderRequest() {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(widget.userRideRequestDetails!.rideRequestId!);

    Map dricerLocationDataMap = {
      "latitude": driverCurrantPosition!.latitude.toString(),
      "longitude": driverCurrantPosition!.longitude.toString(),
    };

    databaseReference.child("status").set("accepted");
    databaseReference.child("driverID").set(driverData.id);
    databaseReference.child("driverName").set(driverData.name);
    databaseReference.child("driverPhone").set(driverData.phone);
    databaseReference.child("car_details").set(
        "${driverData.carColor}${driverData.carModel}${driverData.carNumber}");
    databaseReference.child("driverLocation").set(dricerLocationDataMap);

    saveRideRequestIdToDriverHistory();
  }

//todo: Save Ride Request To Driver History..!

  saveRideRequestIdToDriverHistory() {
    DatabaseReference tripsHistoryRefrence = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("tripshistory");

    tripsHistoryRefrence
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .set(true);
  }

//todo:->  createActiveDriverIconMarker
  createDriverIconMarker() {
    if (iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
        context,
        size: const Size(2, 2),
      );
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "assets/images/car.png")
          .then((value) {
        iconAnimatedMarker = value;
      });
    }
  }
//todo: ->  Update Drivers Location RealTime..

  getDriversLocationsUpdateAtRealTime() {
    LatLng oldLatLng = const LatLng(0, 0);
    streamSubscriptionDriverLivePosition =
        Geolocator.getPositionStream().listen((Position position) {
      onlineDriverCurrentPosition = position;
      driverCurrantPosition = position;

      LatLng latLngLiveDriverPosition = LatLng(
          onlineDriverCurrentPosition!.latitude,
          onlineDriverCurrentPosition!.longitude);
      Marker animatingMarker = Marker(
          markerId: const MarkerId("Animatedmarker"),
          position: latLngLiveDriverPosition,
          icon: iconAnimatedMarker!,
          infoWindow: const InfoWindow(title: "This is your Current Location"));
      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: latLngLiveDriverPosition, zoom: 16);
        newTripGoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(
          cameraPosition,
        ));
        setOfMarker.removeWhere(
            (element) => element.markerId.value == "Animatedmarker");
        setOfMarker.add(animatingMarker);
      });
      oldLatLng = latLngLiveDriverPosition;
      updateDurationTimeAtRealTime();

//? Updateng Driver Location At Real Time In dataBase..
      Map driverLatLngDataMap = {
        "latitude": onlineDriverCurrentPosition!.latitude.toString(),
        "longitude": onlineDriverCurrentPosition!.longitude.toString()
      };
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Request")
          .child(widget.userRideRequestDetails!.rideRequestId!)
          .child("driverLocation")
          .set(driverLatLngDataMap);
    });
  }

//todo: Update Duratin Time At Real Time
  updateDurationTimeAtRealTime() async {
    if (isRequestDirectinDetails == false) {
      isRequestDirectinDetails = true;
      if (onlineDriverCurrentPosition == null) {
        return;
      }
      var originLatLng = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude,
      ); //DriverCurrentLocation
      LatLng? destinationLatLng;
      if (rideRequestStatus == "accepted") {
        destinationLatLng =
            widget.userRideRequestDetails!.originLatLng; //userPickUpLocation
      } else {
        var destinationLatLng = widget
            .userRideRequestDetails!.destinationLatLng; //userDropOffLocation
      }
      var directionInfomation =
          await AssistantMethods.obtainedOriginToDestinationDetails(
              originLatLng, destinationLatLng!);
      if (directionInfomation != null) {
        setState(() {
          durationFromOriginToDestination = directionInfomation.durationText!;
        });
      }
      isRequestDirectinDetails = false;
    }
  }

//todo:  End Trip Now
  endTripNow() async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            const ProgressDialogWidget(message: "Please wait..!"));
    //? Get Trip Direction Details :: distance travlled
    var currentDriverPositionLatLng = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude);

    var tripDirectionDetails =
        await AssistantMethods.obtainedOriginToDestinationDetails(
      currentDriverPositionLatLng,
      widget.userRideRequestDetails!.originLatLng!,
    );

    //? Fare Amount
    double totalFareAmount =
        AssistantMethods.calculateFareAmountFronOriginToDestination(
            tripDirectionDetails!);

    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .child("fareAmount")
        .set(totalFareAmount.toString());
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .child("status")
        .set("ended");

    streamSubscriptionDriverLivePosition.cancel();
    Navigator.pop(context);

    //? Display Fare Amount in Dialog Box..
    showDialog(
        context: context,
        builder: (BuildContext context) => FareAmountCollectionDialog(
              totalFareAmount: totalFareAmount,
            ));
  }

//! InitSectin ..****
  @override
  void initState() {
    super.initState();
    saveAssigenDriverDetailsUserRiderRequest();
  }

//! UI Section...*****

  @override
  Widget build(BuildContext context) {
    createDriverIconMarker();
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

                drawPolyLineFromOriginToDestination(
                    driverCurrentLatLng, userPickUpLocation!);
                getDriversLocationsUpdateAtRealTime();
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
                    Text(
                      durationFromOriginToDestination,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: buttonColors,
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
                        onPressed: () async {
                          //? driver has arrived at user pickUp location :: Arvied Button
                          if (rideRequestStatus == "accepted") {
                            rideRequestStatus = "arrived";
                            FirebaseDatabase.instance
                                .ref()
                                .child("All Ride Request")
                                .child(widget
                                    .userRideRequestDetails!.rideRequestId!)
                                .child("status")
                                .set(rideRequestStatus);

                            setState(() {
                              buttonTile = "Start Trip";
                              buttonColors = buttonColors;
                            });

                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) =>
                                    const ProgressDialogWidget(
                                        message: "Loading..!"));

                            await drawPolyLineFromOriginToDestination(
                                widget.userRideRequestDetails!.originLatLng!,
                                widget.userRideRequestDetails!
                                    .destinationLatLng!);

                            Navigator.pop(context);
                            //? User Has Already Sit in driver Car.. ::Lets Go
                          } else if (rideRequestStatus == "arrived") {
                            rideRequestStatus = "onTrip";
                            FirebaseDatabase.instance
                                .ref()
                                .child("All Ride Request")
                                .child(widget
                                    .userRideRequestDetails!.rideRequestId!)
                                .child("status")
                                .set(rideRequestStatus);
                            setState(() {
                              buttonTile = "End Trip";
                              buttonColors = Colors.red;
                            });
                          }
                          //? Driver Reached Destination Point (END TRIP).. ::
                          //!End Trip
                          else if (rideRequestStatus == "onTrip") {
                            endTripNow();
                          }
                        },
                        icon: Icon(
                          Icons.directions_car,
                          size: 25,
                          color: buttonColors,
                        ),
                        label: Text(
                          buttonTile!,
                          style: TextStyle(
                            color: buttonColors,
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
