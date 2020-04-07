import 'dart:ui';

import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatefulWidget {

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {


  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 3/4,
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
              Positioned(
                bottom: -20,
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
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 30)),
        Text(
          'Some Text'
        )
      ],
    );
  }

  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: <Widget> [
  //       Expanded(
  //         child: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(Radius.circular(20)),
  //             image: DecorationImage(
  //               image: NetworkImage("https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/baked-honey-feta.jpg"),
  //               fit: BoxFit.cover
  //             )
  //           ),
  //         ),
  //       ),
  //     ]
  //   );
  // }
}