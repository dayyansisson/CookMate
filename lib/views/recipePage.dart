import 'dart:ui';

import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {

  /* Layout Constants */
  static const double _PAGE_NAME_FONT_SIZE = 16;
  static const double _TOP_BAR_EDGE_PADDING = 30;

  final String _imageURL = "https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/carnitas-bowl.jpg";
  
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(_imageURL),
              colorFilter: ColorFilter.mode(Colors.black26, BlendMode.overlay),
              fit: BoxFit.cover
            )
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(  // Top Bar
              padding: const EdgeInsets.only(top: _TOP_BAR_EDGE_PADDING, right: _TOP_BAR_EDGE_PADDING, left: _TOP_BAR_EDGE_PADDING),
              child: Row(
                children: <Widget>[
                  Text(
                    "BACK",
                    style: TextStyle(
                      color: StyleSheet.WHITE,
                      fontWeight: FontWeight.bold,
                      fontSize: _PAGE_NAME_FONT_SIZE
                    ),
                  ),
                  Spacer(),
                  snackbar,
                ]
              ),
            ),
            Spacer(),
            RecipeTab()
          ],
        )
      ],
    );
  }

  // TODO: Replace with actual Menu widget
  Widget get snackbar {
    return Container(
      width: 16,
      child: Column(
        children: <Widget>[
          Container(height: 2, color: StyleSheet.WHITE),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          Container(height: 2, color: StyleSheet.WHITE),
        ],
      ),
    );
  }
}

class RecipeTab extends StatefulWidget {

  @override
  _RecipeTabState createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {

  /* Layout Constants */
  static const double _SHEET_BORDER_RADIUS = 40;
  static const double _TITLE_SIZE = 36;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(_SHEET_BORDER_RADIUS),
        topRight: Radius.circular(_SHEET_BORDER_RADIUS)
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: StyleSheet.BLACK.withOpacity(0.4),
          child: Stack(
            children: <Widget> [
              _header,
            ]
          ),
        ),
      ),
    );
  }

  Widget get _header {
    return Column(
      children: <Widget> [
        _title,
        SizedBox(height: 14),
        _description,
        _horizontalInfoBar
      ]
    );
  }

  /* Getter for the header segment of the sheet */
  Widget get _title {
    
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(    // Rounded edges
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_SHEET_BORDER_RADIUS),
              topRight: Radius.circular(_SHEET_BORDER_RADIUS)
            )
          ),
          height: _SHEET_BORDER_RADIUS + _TITLE_SIZE,
        ),
        Positioned(
          top: 14,
          child: Container(
            width: 40,
            height: 6,
            decoration: BoxDecoration(
              color: StyleSheet.WHITE.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(_SHEET_BORDER_RADIUS))
            ),
          ),
        ),
        Positioned(  // Navigation
          top: _SHEET_BORDER_RADIUS,
          left: _SHEET_BORDER_RADIUS,
          child: Text(
            "Carnitas Bowl",
            style: TextStyle(
              fontSize: _TITLE_SIZE,
              fontFamily: 'Hoefler',
              color: StyleSheet.WHITE,
            ),
          )
        ),
      ],
    );
  }

  Widget get _description {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _SHEET_BORDER_RADIUS),
        child: Text(
          "Wild rice’s nutty and earthy flavors elevate an otherwise boring dish instantly.",
          style: TextStyle(
            fontSize: 20,
            color: StyleSheet.WHITE,
            fontWeight: FontWeight.w300
          ),
        ),
      ),
    );
  }

  Widget get _horizontalInfoBar {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _SHEET_BORDER_RADIUS, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _basicInfo("Prep", "15 min"),
          _basicInfo("Cook", "10 min"),
          _basicInfo("Serves", "4-6")
        ],
      ),
    );
  }

  Widget _basicInfo(String title, String data) {

    return Column(
      children: <Widget> [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: StyleSheet.WHITE,
            fontSize: 15
          ),
        ),
        Text(
          data.toUpperCase(),
          style: TextStyle(
            color: StyleSheet.WHITE,
            fontSize: 14,
            fontWeight: FontWeight.w300
          ),
        ),
      ]
    );
  }
}