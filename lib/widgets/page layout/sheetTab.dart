import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';

class SheetTab {

  final String name;

  final Widget _headerContent;
  Widget get headerContent {

    if(_headerContent == null) {
      return Container();
    } else {
      return _headerContent;
    }
  }

  final Widget _bodyContent;
  Widget get bodyContent => Container(child: _bodyContent);

  final String backgroundImage;
  final String title;
  final String subtitle;
  final Gradient bodyGradient;

  SheetTab({
    this.name, 
    Widget headerContent, 
    Widget bodyContent,
    this.backgroundImage,
    this.title,
    this.subtitle,
    this.bodyGradient = StyleSheet.VERTICAL_GRADIENT_LIGHT
  }) : _headerContent = headerContent, _bodyContent = bodyContent;
}