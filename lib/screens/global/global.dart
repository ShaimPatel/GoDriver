import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;

//! Drivers List Driver Key Containe info.
List dList = [];
