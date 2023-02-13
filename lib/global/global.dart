import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/driver_data.dart';

//! Global Variable . To Access Glovaly to It -- :: --

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
late StreamSubscription<Position> streamSubscription;
late StreamSubscription<Position> streamSubscriptionDriverLivePosition;

User? currentFirebaseUser;
DriverModel? driverModelCurrentInfo;
Position? driverCurrantPosition;

AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
DriverData driverData = DriverData();

String statusText = "Now Offline";
String titleStarRating = "Good";
String? driverVehicleType = "";

Color buttonsColor = Colors.grey;
bool isDriverActive = false;
