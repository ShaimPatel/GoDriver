import 'package:flutter/widgets.dart';
import 'package:users_app/models/direction.dart';

import '../models/history_model.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  int counttotelTrips = 0;
  List<String> historyTripKeyList = [];
  List<TripHistotyModel> allTripsHistoryInformationList = [];

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

//todo :: Update Over All Trips Counter
  updateOverAllTripsCounter(int overAllTripsCounter) {
    counttotelTrips = overAllTripsCounter;
    notifyListeners();
  }

//todo  :: Update Over All Trips Keys
  updateOverAllTripsKeys(List<String> tripskeysList) {
    historyTripKeyList = tripskeysList;
    notifyListeners();
  }

  //todo :: Update  Over All Trips History Infromation
  updateOverAllTripsHistoryInformatin(TripHistotyModel historyTrips) {
    allTripsHistoryInformationList.add(historyTrips);
    notifyListeners();
  }
}
