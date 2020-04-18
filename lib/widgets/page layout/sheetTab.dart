import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';

class SheetTab {

  final String name;

  final Widget _bodyContent;
  Widget get bodyContent => Container(decoration: BoxDecoration(gradient: bodyGradient), child: _bodyContent);

  String backgroundImage;
  final Future<String> futureBackground;
  final String title;
  final String subtitle;
  final Gradient bodyGradient;
  final bool canExpandSheet;

  SheetTab({
    @required this.name, 
    @required Widget bodyContent,
    this.backgroundImage,
    this.futureBackground,
    this.title,
    this.subtitle,
    this.bodyGradient = StyleSheet.VERTICAL_GRADIENT_LIGHT,
    this.canExpandSheet = false
  }) : _bodyContent = bodyContent {
    loadBackground();
  }

  void loadBackground() async => backgroundImage = await futureBackground;
}