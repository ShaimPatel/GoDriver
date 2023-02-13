// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

class InfoDesignUIWidget extends StatefulWidget {
  String? textInfo;
  IconData? iconData;

  InfoDesignUIWidget({
    Key? key,
    this.textInfo,
    this.iconData,
  }) : super(key: key);

  @override
  State<InfoDesignUIWidget> createState() => _InfoDesignUIWidgetState();
}

class _InfoDesignUIWidgetState extends State<InfoDesignUIWidget> {
  //! UI Section    -- :: --
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white54,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: Colors.black,
        ),
        title: Text(
          widget.textInfo!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
