import 'dart:ui';
import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/provider/recipeModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/views/recipePage.dart';
import 'package:CookMate/widgets/fadeImage.dart';
import 'package:CookMate/widgets/favoriteButton.dart';
import 'package:CookMate/widgets/marquee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatefulWidget {

  final Recipe recipe;
  RecipeCard(this.recipe);

  // TODO implement multiple layouts
  // TODO implement general scaling
  // TODO account for text overflow
  // TODO what if the heart cannot be seen

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {

  RecipePageModel model;

  @override
  void initState() {

    model = RecipePageModel(recipe: widget.recipe);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<RecipePageModel>(
      create: (_) => model,
      child: Button(
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider<RecipePageModel>.value(
              value: model,
              child: RecipePage()
            );
          }
        )),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: AspectRatio(
                      aspectRatio: 3/2,
                      child: FadeImage(widget.recipe.image),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(child: FavoriteButton())
                  )
                ],
              ),
              Transform.translate(
                offset: Offset(0, -20),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 150, 
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            widget.recipe.category.toUpperCase(),
                            style: TextStyle(
                              color: StyleSheet.BLACK.withOpacity(0.3),
                              fontSize: 12
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Transform.translate(
                      offset: Offset(0, -8),
                      child: Marquee(
                        widget.recipe.title,
                        style: TextStyle(
                          fontFamily: 'Hoefler',
                          fontSize: 22,
                          color: StyleSheet.DEEP_GREY
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "TIME",
                          style: TextStyle(color: StyleSheet.GREY),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                        Text(
                          widget.recipe.cookTime ?? '',   // TODO make prep+cook
                          style: TextStyle(
                            color: StyleSheet.GREY,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                        Text(
                          "SERVINGS",
                          style: TextStyle(color: StyleSheet.GREY),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                        Text(
                          widget.recipe.servings ?? '',
                          style: TextStyle(
                            color: StyleSheet.GREY,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                      ],
                    ),
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}