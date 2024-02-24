import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Constants {
  static const appName = "Englico";

  static const Color kPrimaryColor = Color(0xFF766AA3);
  static const Color kSecondColor = Color(0xFF694980);
  static const Color kThirdColor = Color(0xFFA8478E);
  static const Color kFourthColor = Color(0xFFD7638A);
  static const Color kFifthColor = Color(0xFFF09290);
  static const Color kSixthColor = Color(0xFFF7C6A3);

  static const InputDecoration kInputDecorationWithNoBorder = InputDecoration(
    border: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
  );

  static const TextStyle kTextStyle = TextStyle(fontSize: 17,);
  static const TextStyle kTitleTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);


}