import 'package:flutter/material.dart';
import 'package:take_picture_app/Colors.dart' as c;
import 'package:take_picture_app/widgets/style.dart';
// import 'package:kasanah_mobile/core/style/Constants.dart';

Dialog WDialog_TextAlert(
    BuildContext context, String title, String description) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return Dialog(
    elevation: 0,
    backgroundColor: c.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Container(
      width: mediaW / 1.5,
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(description),
          ),
        ],
      ),
    ),
  );
}

SnackBar WSnackBar_TextAlert(
    BuildContext context, String title, String description) {
  double mediaW = MediaQuery.of(context).size.width;
  double mediaH = MediaQuery.of(context).size.height;
  return SnackBar(
    backgroundColor: (Colors.black12),
    content: Container(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding),
      width: mediaW / 13, // Width of the SnackBar.
      height: mediaH / 13,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    ),
    duration: const Duration(milliseconds: 1500),
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0, // Inner padding for SnackBar content.
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
