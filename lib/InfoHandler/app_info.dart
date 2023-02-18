import 'package:flutter/widgets.dart';

import '../models/direction.dart';
import '../models/history_model.dart';

class AppInfo extends ChangeNotifier {
//! Initlixation Section of a Class -- :: --

  Directions? userPickUpLocation, userDropOffLocation;

  List<String> historyTripKeyList = [];
  List<TripHistotyModel> allTripsHistoryInformationList = [];

  String driverTotalEarnins = "0";
  String driverAvarageRatings = "0";
  int counttotelTrips = 0;

//todo ::-> Update Pick Up Location Address.. Using Provider -- :: --

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

//todo :: -> Update Drop Off Location Address . Using Provider -- :: --

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

//todo :: Update Over All Trips Counter  -- :: --
  updateOverAllTripsCounter(int overAllTripsCounter) {
    counttotelTrips = overAllTripsCounter;
    notifyListeners();
  }

//todo  :: Update Over All Trips Keys  -- :: --
  updateOverAllTripsKeys(List<String> tripskeysList) {
    historyTripKeyList = tripskeysList;
    notifyListeners();
  }

  //todo :: Update  Over All Trips History Infromation  -- :: --
  updateOverAllTripsHistoryInformatin(TripHistotyModel historyTrips) {
    allTripsHistoryInformationList.add(historyTrips);
    notifyListeners();
  }

  //todo  :: Update Drivers Total Earnind -- :: --
  updateDriverTotalEarnings(String totalEarnig) {
    driverTotalEarnins = totalEarnig;
    // notifyListeners();
  }

  //todo :: Update Driver Avarge Rating -- :: --
  updateDriverAvarageRating(String driverRating) {
    driverAvarageRatings = driverRating;
    notifyListeners();
  }
}
