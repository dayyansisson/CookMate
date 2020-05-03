import 'dart:ui';
import 'package:CookMate/provider/recipeModel.dart';
import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/cookMateIcons.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/favoriteButton.dart';
import 'package:CookMate/widgets/page%20layout/recipeSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipePage extends StatefulWidget {

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {

  /* Layout Constants */
  static const double _PAGE_NAME_FONT_SIZE = 16;
  static const double _TOP_BAR_EDGE_PADDING = 15;

  @override
  Widget build(BuildContext context) {

    return Consumer<RecipeModel>(
      builder: (context, recipe, loadingScreen) {
        if(recipe.isReadyForDisplay) {
          return buildPage(context, recipe);
        }
        recipe.loadRecipeForDisplay();
        return loadingScreen;
      },
      child: Container(
        color: StyleSheet.WHITE,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildPage(BuildContext context, RecipeModel recipe) {

    return Scaffold(
      backgroundColor: StyleSheet.WHITE,
      body: Stack(
        children: <Widget>[
           ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment(0, -1),
                end: Alignment(0, -0.75),
                colors: [Colors.black26, Colors.transparent],
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.hardLight,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(recipe.imageURL),
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
          Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              ChangeNotifierProvider(
                create: (_) => TabNavigationModel(tabCount: 2, expandSheet: true),
                child: RecipeSheet()
              ),
              Padding(  // Top Bar
                padding: const EdgeInsets.only(top: _TOP_BAR_EDGE_PADDING, right: _TOP_BAR_EDGE_PADDING, left: _TOP_BAR_EDGE_PADDING),
                child: Container(
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      roundedBackground([
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
                      ]),
                      Spacer(),
                      roundedBackground([
                        Icon(
                          CookMateIcon.bag_icon,
                          color: StyleSheet.WHITE,
                        ),
                        Container(width: 20),
                        FavoriteButton()
                      ]),
                    ]
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget roundedBackground (List<Widget> widgets) {

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 100,
          alignment: Alignment.center,
          color: StyleSheet.DEEP_GREY.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widgets,
            ),
          ),
        )
      ),
    );
  }
}