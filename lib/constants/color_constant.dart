import 'package:flutter/material.dart';

class BaseTheme {
  Color get PrimaryTheme => fromHex('FF2641');
  Color get appBarColor => fromHex('d19827');
  Color get drawerColor => fromHex('191D4B');

  LinearGradient LinearGradientWidget(){
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromRGBO(46, 47, 85, 1),
        Color.fromRGBO(25, 29, 75, 1),
      ],
    );
  }

  LinearGradient LinearGradientWidget1(){
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromRGBO(211, 35, 142, 1),
        Color.fromRGBO(199, 83, 142, 1),
      ],
    );
  }
}

BaseTheme get appTheme => BaseTheme();

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
