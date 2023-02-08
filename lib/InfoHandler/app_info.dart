import 'package:flutter/widgets.dart';
import 'package:users_app/models/direction.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;

//todo ::-> Update Pick Up Location Address.. Using Provider .

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

//todo :: -> Update Drop Off Location Address . Using Provider.

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
