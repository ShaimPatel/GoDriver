import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:users_app/Widgets/place_prediction_tile.dart';
import 'package:users_app/assistant/request_assistant.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/screens/global/map_key.dart';

import '../../Widgets/progess_dialog.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  //! FindPlaceAutoComplete..
  List<PredictedPlaces> placePredictedList = [];

  //! Widget For Progress Bar
  Future<void> progressBarIndicator() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return const ProgressDialogWidget();
        });
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }
//todo :: Find Place Auto Comlete Search -- :: --

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

//!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //! Search Place UI
          Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              boxShadow: const [
                BoxShadow(
                  color: Colors.white54,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),
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
                          color: Colors.black,
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Search Destinatoion ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                        Icons.place,
                        color: Colors.black,
                        size: 35,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (valueTyped) {
                              findPlaceAutoCompleteSearch(valueTyped);
                            },
                            textInputAction: TextInputAction.done,
                            cursorColor: HexColor("#4f4f4f"),
                            decoration: InputDecoration(
                              hintText: "Search Place ..! ",
                              fillColor: HexColor("#f0f3f1"),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              prefixIconColor: HexColor("#44564a"),
                              filled: true,
                            ),
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
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2, top: 2),
                      child: Divider(
                        height: 2,
                        color: Colors.green[100],
                        thickness: 2,
                        indent: 15,
                        endIndent: 15,
                      ),
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
