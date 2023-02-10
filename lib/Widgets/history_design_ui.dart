// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:users_app/models/history_model.dart';

class HistoryDesignUIWedget extends StatefulWidget {
  TripHistotyModel tripHistotyModel;
  HistoryDesignUIWedget({
    Key? key,
    required this.tripHistotyModel,
  }) : super(key: key);

  @override
  State<HistoryDesignUIWedget> createState() => _HistoryDesignUIWedgetState();
}

class _HistoryDesignUIWedgetState extends State<HistoryDesignUIWedget> {
//todo :: Formate Date time
  String fromateDateAndTime(String dateTimeFromDB) {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);
    //? Jan 10                               //? 2023                              //? 1:12 pm
    String formatedDateTime =
        "${DateFormat.MMMd().format(dateTime)} , ${DateFormat.y().format(dateTime)} -  ${DateFormat.jm().format(dateTime)}";
    return formatedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.30,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
          child: Column(
            children: [
              //? driver name + fare amount .
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tripHistotyModel.driverName.toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "₹ ${widget.tripHistotyModel.fareAmount}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Divider(height: 3, thickness: 4),
              const SizedBox(height: 10),
              //? Car details
              Row(
                children: [
                  const Icon(
                    Icons.car_repair,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.tripHistotyModel.cardetails.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              //? PickUp
              Row(
                children: [
                  //? PickUp
                  Image.asset(
                    "assets/images/origin.png",
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.tripHistotyModel.originAddress.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              //? DropOff
              Row(
                children: [
                  //? PickUp
                  Image.asset(
                    "assets/images/destination.png",
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.tripHistotyModel.destinationAddress.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 2),
              const SizedBox(height: 5),

              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(50)),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    fromateDateAndTime(
                      widget.tripHistotyModel.time!.toString(),
                    ),
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
