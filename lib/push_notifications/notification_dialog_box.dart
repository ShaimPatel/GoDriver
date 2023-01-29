// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_app/global/global.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/models/user_ride_request_infomation.dart';

class NotificationDialogBox extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;
  NotificationDialogBox({
    Key? key,
    this.userRideRequestDetails,
  }) : super(key: key);

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent,
      elevation: 1,
      child: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            //? Origin And Destination Button..
            const SizedBox(height: 20.0),
            Image.asset(
              "assets/images/car_logo.png",
              width: 160,
            ),
            const SizedBox(height: 5),
            const Text("New Ride Request ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                )),
            const SizedBox(height: 12.0),
            const Divider(
              thickness: 1,
              height: 3,
              indent: 15,
              color: Colors.grey,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //? Origin Location with Icon..
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/origin.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails!.originAddress!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/destination.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails!.destinationAddress!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  //? Destinatin Location with Icon..
                ],
              ),
            ),

            const Divider(
              thickness: 1,
              height: 3,
              indent: 25,
              color: Colors.grey,
              endIndent: 25,
            ),
            //? Cancle And Accept Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //? For Cancle
                  ElevatedButton(
                    onPressed: () {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancle'.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  //For Accept
                  ElevatedButton(
                    onPressed: () {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'Accept'.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
