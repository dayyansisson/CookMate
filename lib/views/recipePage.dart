import 'dart:ui';
import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/favoriteButton.dart';
import 'package:CookMate/widgets/page%20layout/recipeSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipePage extends StatefulWidget {

  final Recipe recipe;
  final Future<Recipe> futureRecipe;

  RecipePage({this.recipe, this.futureRecipe});

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {

  /* Layout Constants */
  static const double _PAGE_NAME_FONT_SIZE = 16;
  static const double _TOP_BAR_EDGE_PADDING = 30;

  Recipe recipe;

  @override
  void initState() { 
    super.initState();

    loadRecipe();
  }

  void loadRecipe() async {
    
    Recipe futureRecipe = widget.recipe;
    if(widget.futureRecipe != null) {
      futureRecipe = await widget.futureRecipe;
    }

    List<Future> preloads = [
      futureRecipe.getIngredients(),
      futureRecipe.getSteps(),
      futureRecipe.getTags(),
      futureRecipe.isFavorite()
    ];
    await Future.wait(preloads);
    
    setState(() {
      recipe = futureRecipe;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(recipe != null) {
      return buildPage(context);
    }

    return Container(
      color: StyleSheet.WHITE,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  Widget buildPage(BuildContext context) {

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
                  image: NetworkImage(recipe.image),
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.softLight),
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
          Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Padding(  // Top Bar
                padding: const EdgeInsets.only(top: _TOP_BAR_EDGE_PADDING - 20, right: _TOP_BAR_EDGE_PADDING, left: _TOP_BAR_EDGE_PADDING),
                child: Container(
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      FavoriteButton(
                        recipe: recipe,
                        disabledIcon: Icon(
                          Icons.favorite_border,
                          color: StyleSheet.WHITE,
                          size: 30,
                        ),
                        enabledIcon: Icon(
                          Icons.favorite,
                          color: StyleSheet.WHITE,
                          size: 30,
                        ),
                        size: 30,
                      ),
                    ]
                  ),
                ),
              ),
              ChangeNotifierProvider(
                create: (_) => TabNavigationModel(tabCount: 2, expandSheet: true),
                child: RecipeSheet(recipe)
              )
            ],
          )
        ],
      ),
    );
  }
}