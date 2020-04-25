import 'dart:ui';
import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/page%20layout/recipeSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipePage extends StatelessWidget {

  /* Layout Constants */
  static const double _PAGE_NAME_FONT_SIZE = 16;
  static const double _TOP_BAR_EDGE_PADDING = 30;

  final String _imageURL = "https://ethosfun.com/wp-content/uploads/2019/09/bowl-cuisine-delicious-2067473.jpg";
  
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
        Stack(
          children: <Widget>[
            Padding(  // Top Bar
              padding: const EdgeInsets.only(top: _TOP_BAR_EDGE_PADDING, right: _TOP_BAR_EDGE_PADDING, left: _TOP_BAR_EDGE_PADDING),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Button(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "BACK",
                      style: TextStyle(
                        color: StyleSheet.WHITE,
                        fontWeight: FontWeight.bold,
                        fontSize: _PAGE_NAME_FONT_SIZE
                      ),
                    ),
                  ),
                  Spacer(),
                  snackbar,
                ]
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => TabNavigationModel(tabCount: 2),
              child: RecipeSheet()
            )
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