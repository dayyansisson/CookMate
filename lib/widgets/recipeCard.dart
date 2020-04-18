import 'dart:ui';
import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatefulWidget {

  // TODO take in recipe entity
  // TODO implement multiple layouts
  // TODO implement general scaling
  // TODO implement button functionality

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 3/2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  image: NetworkImage("https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/baked-honey-feta.jpg"),
                  fit: BoxFit.cover
                )
              ),
            ),
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
                        "APPETIZER",
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
                  child: Text(
                    'Tofu Fries',
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
                      "8 MIN",
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
                      "2-3",
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
    );
  }
}