// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PayFareAmountDialog extends StatefulWidget {
  double? fareAmount;

  PayFareAmountDialog({
    Key? key,
    this.fareAmount,
  }) : super(key: key);

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}

class _PayFareAmountDialogState extends State<PayFareAmountDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.all(6),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Text(
                  "Pay Fare Amount ".toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(
                  thickness: 2,
                  color: Colors.white38,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 16),
                Text(
                  "₹ : ${widget.fareAmount}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "This is the Total trip Fare Amount , Please Pay it to the driver . ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pop(context, "cashPayed");
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        textStyle: const TextStyle(fontSize: 16),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text("\u{20B9}",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              )),
                          Text("Pay Amount",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Positioned(
            top: -30,
            left: -20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 40,
                height: 40,
                color: Colors.blueGrey,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
