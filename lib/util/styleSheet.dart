import 'package:flutter/material.dart';

class StyleSheet {
  
  /* Colors */
  static const Color DEEP_GREY = const Color(0xFF262626);
  static const Color DARK_GREY = const Color(0xFF4D4D4D);
  static const Color GREY = const Color(0xFF8E8E8E);
  static const Color LIGHT_GREY = const Color(0xFFACACAC);
  static const Color FADED_GREY = const Color(0xFFCBCBCB);
  static const Color WHITE = const Color(0xFFFFFFFF);
  static const Color TRANSPARENT = const Color(0x00FFFFFF);

  /* Gradients */
  static const LinearGradient VERTICAL_GRADIENT_LIGHT = const LinearGradient(
    colors: const <Color> [ WHITE, WHITE, const Color(0xFFF5F5F5) ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter
  );

  /* Theming */
  static get theme => _theme;
  static ThemeData _theme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Lato',
  );
}