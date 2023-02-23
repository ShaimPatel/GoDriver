import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/InfoHandler/app_info.dart';
import 'package:users_app/Widgets/progess_dialog.dart';
import 'package:users_app/assistant/request_assistant.dart';
import 'package:users_app/models/direction.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/screens/global/global.dart';
import 'package:users_app/screens/global/map_key.dart';

class PlacePredictionTileDesign extends StatefulWidget {
  const PlacePredictionTileDesign({super.key, this.predictedPlaces});
  final PredictedPlaces? predictedPlaces;

  @override
  State<PlacePredictionTileDesign> createState() =>
      _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {
  //! Here are getPlaceDirectionDetails..
  getPlaceDirectionDetails(String placeId, context) async {
    showDialog(
        context: context, builder: (context) => const ProgressDialogWidget());

    String placeDirectionDetailsURL =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseAPI =
        await RequestAssistant.receiveRequest(placeDirectionDetailsURL);

    Navigator.pop(context);

    if (responseAPI == "Error Occured, Failed No Response.") {
      return;
    }

    if (responseAPI["status"] == "OK") {
      Directions directions = Directions();
      directions.locationName = responseAPI["result"]["name"];
      directions.locationLatitude =
          responseAPI["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =
          responseAPI["result"]["geometry"]["location"]["lng"];
      directions.locationID = placeId;

      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocationAddress(directions);
      setState(() {
        userDropOffAddress = directions.locationName!;
      });
      Navigator.pop(context, "obtainedDropoff");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ElevatedButton(
        onPressed: () {
          getPlaceDirectionDetails(widget.predictedPlaces!.placeId!, context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[100],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              const Icon(
                Icons.place_rounded,
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    Text(
                      widget.predictedPlaces!.mainText!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      widget.predictedPlaces!.secondaryText!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
