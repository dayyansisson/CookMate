import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/searchBar.dart';
import 'package:flutter/material.dart';

class SheetTab {

  final String name;

  final Widget _bodyContent;
  Widget get bodyContent => Container(decoration: BoxDecoration(gradient: bodyGradient), child: _bodyContent);

  final String backgroundImage;
  final String header;
  final String subheader;
  final Gradient bodyGradient;
  final bool canExpandSheet;
  final SearchBar searchBar;

  SheetTab({
    @required this.name, 
    @required Widget bodyContent,
    this.backgroundImage,
    this.header,
    this.subheader,
    this.bodyGradient = StyleSheet.VERTICAL_GRADIENT_LIGHT,
    this.canExpandSheet = false,
    this.searchBar
  }) : _bodyContent = bodyContent;
}