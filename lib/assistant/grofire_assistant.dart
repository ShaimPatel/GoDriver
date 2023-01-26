import 'package:users_app/models/active_nearby_avilable_drivers.dart';

class GeoFireAssistant {
  static List<ActiveNearbyAvilableDrivers> activeNearbyAvilableDriversList = [];

  // DeleteOfflineDriver From List
  static void deleteOfflineDriverFromList(String driverId) {
    int indexNumber = activeNearbyAvilableDriversList
        .indexWhere((element) => element.driverID == driverId);
    activeNearbyAvilableDriversList.removeAt(indexNumber);
  }

  //Update driver move
  static void updateActiveNearbyAvailableDriverLocation(
      ActiveNearbyAvilableDrivers driverWhoMove) {
    int indexNumber = activeNearbyAvilableDriversList
        .indexWhere((element) => element.driverID == driverWhoMove.driverID);
    activeNearbyAvilableDriversList[indexNumber].locationLatitude =
        driverWhoMove.locationLatitude;
    activeNearbyAvilableDriversList[indexNumber].locationLongitude =
        driverWhoMove.locationLongitude;
  }
}
