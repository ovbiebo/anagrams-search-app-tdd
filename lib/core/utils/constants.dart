import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double horizontalBlockSize;
  static double verticalBlockSize;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    horizontalBlockSize = screenWidth / 100;
    verticalBlockSize = screenHeight / 100;
  }
}

const questrialStyle = TextStyle(
  fontFamily: "Questrial",
);

const subtextColor = Color.fromRGBO(255, 255, 255, 0.4);

final largeTextfieldDecoration = InputDecoration(
    border: InputBorder.none,
    hintStyle: TextStyle(
      fontFamily: "Questrial",
      decoration: TextDecoration.underline,
      fontSize: SizeConfig.horizontalBlockSize * 8,
      color: subtextColor,
    )
);

final largeTextfieldStyle = TextStyle(
  fontFamily: "Questrial",
  decoration: TextDecoration.underline,
  fontSize: SizeConfig.horizontalBlockSize * 8,
  color: Colors.white,
);