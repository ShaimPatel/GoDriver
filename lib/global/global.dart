import 'dart:async';

import 'package:driver_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
DriverModel? driverModelCurrentInfo;
late StreamSubscription<Position> streamSubscription;
