import 'dart:ui';
import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/views/recipePage.dart';
import 'package:CookMate/widgets/favoriteButton.dart';
import 'package:CookMate/widgets/marquee.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatefulWidget {

  final Recipe recipe;
  RecipeCard(this.recipe);

  // TODO implement multiple layouts
  // TODO implement general scaling

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {

  @override
  Widget build(BuildContext context) {

    return Button(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage(recipe: widget.recipe,))),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 3/2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        image: NetworkImage(widget.recipe.image),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: FavoriteButton(recipe: widget.recipe)
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
                        fontSize: 26,
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
                        widget.recipe.cookTime == null ? '' : widget.recipe.cookTime,   // TODO make prep+cook
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
                        widget.recipe.servings == null ? '' : widget.recipe.servings,
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
    );
  }
}