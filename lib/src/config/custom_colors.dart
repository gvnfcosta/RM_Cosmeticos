import 'package:flutter/material.dart';

Map<int, Color> _swatchOpacity = {
  50: const Color.fromRGBO(240, 110, 240, .1),
  110: const Color.fromRGBO(240, 110, 240, .2),
  200: const Color.fromRGBO(240, 110, 240, .3),
  300: const Color.fromRGBO(240, 110, 240, .4),
  400: const Color.fromRGBO(240, 110, 240, .5),
  500: const Color.fromRGBO(240, 110, 240, .6),
  600: const Color.fromRGBO(240, 110, 240, .7),
  700: const Color.fromRGBO(240, 110, 240, .8),
  800: const Color.fromRGBO(240, 110, 240, .9),
  900: const Color.fromRGBO(240, 110, 240, 1),
};

abstract class CustomColors {
  static Color customContrastColor = Colors.pink.shade600;
  static MaterialColor customSwatchColor =
      MaterialColor(0xFFF36EF3, _swatchOpacity);
}
