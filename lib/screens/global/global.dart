import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/direction_details_info.dart';

import '../../models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;

//! Drivers List Driver Key Containe info.
List dList = [];
DirectionDetailsInfo? tripdirectionDetailsInfo;
String? selectedDriverId;
String driverCarDetails = "";
String driverPhone = '';
String driverName = '';
String userDropOffAddress = '';
double countRatingstar = 0.0;
String titleStarRating = 'All Is Ok';
