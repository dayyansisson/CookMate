import 'package:flutter/material.dart';

class StyleSheet {
  
  /* Colors */
  static const Color BLACK = const Color(0xFF000000);
  static const Color DEEP_GREY = const Color(0xFF262626);
  static const Color DARK_GREY = const Color(0xFF4D4D4D);
  static const Color GREY = const Color(0xFF8E8E8E);
  static const Color LIGHT_GREY = const Color(0xFFACACAC);
  static const Color FADED_GREY = const Color(0xFFCBCBCB);
  static const Color WHITE = const Color(0xFFFFFFFF);
  static const Color TRANSPARENT = const Color(0x00FFFFFF);

  /* Gradients */
  static const LinearGradient VERTICAL_GRADIENT_WHITE = const LinearGradient(
    colors: const <Color> [ WHITE, WHITE, const Color(0xFFF5F5F5) ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter
  );

  static const LinearGradient VERTICAL_GRADIENT_LIGHT = const LinearGradient(
    colors: const <Color> [ const Color(0xFFFAFAFA), const Color(0xFFFAFAFA), const Color(0xFFF5F5F5) ],
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

class Button extends StatelessWidget {

  final Widget child;
  final Function onPressed;
  final Color splashColor;
  Button(
    {
      @required this.child,
      @required this.onPressed, 
      this.splashColor = StyleSheet.TRANSPARENT
    }
  );

  @override
  Widget build(BuildContext context) {

    return RawMaterialButton(
      constraints: BoxConstraints(),
      highlightColor: StyleSheet.TRANSPARENT,
      splashColor: splashColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: onPressed,
      child: child
    );
  }
}