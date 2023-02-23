// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressDialogWidget extends StatelessWidget {
  const ProgressDialogWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //! UI Section -- :: --
    return Center(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10),
          // shape: BoxShape.circle,
        ),
        child: const CupertinoActivityIndicator(
          color: Colors.white,
          radius: 30,
          animating: true,
        ),
      ),
    );
  }
}
