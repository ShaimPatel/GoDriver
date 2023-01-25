import 'package:flutter/material.dart';
import 'package:users_app/Widgets/place_prediction_tile.dart';
import 'package:users_app/assistant/request_assistant.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/screens/global/map_key.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  //! FindPlaceAutoComplete..
  List<PredictedPlaces> placePredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:IN";

      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearch);
      if (responseAutoCompleteSearch == "Error Occured, Failed No Response.") {
        return;
      }
      if (responseAutoCompleteSearch["status"] == "OK") {
        var placesPredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionList = (placesPredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();
        setState(() {
          placePredictedList = placePredictionList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //! Search Place UI
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.black54, boxShadow: [
              BoxShadow(
                  color: Colors.white54,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7))
            ]),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Search & Set Drop of Location",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (valueTyped) {
                              findPlaceAutoCompleteSearch(valueTyped);
                            },
                            decoration: const InputDecoration(
                                hintText: "Search here..!",
                                fillColor: Colors.white54,
                                filled: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: 11.0,
                                  top: 8.0,
                                  bottom: 8.0,
                                )),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ), //! Display place Prediction text
          (placePredictedList.isNotEmpty)
              ? Expanded(
                  child: ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (ctx, i) {
                    return PlacePredictionTileDesign(
                      predictedPlaces: placePredictedList[i],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 1,
                      color: Colors.grey,
                      thickness: 1,
                    );
                  },
                  itemCount: placePredictedList.length,
                ))
              : Container()
        ],
      ),
    );
  }
}
