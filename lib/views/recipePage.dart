import 'dart:ui';
import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/page%20layout/recipeSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipePage extends StatelessWidget {

  /* TODO REMOVE CONSTANTS */
  final Recipe recipe = Recipe(
    id: -1,
    title: "Wild Rice & Eggs",
    description: "Wild rice's nutty and earthy flavors elevate an otherwise boring dish instantly.",
    //image: "https://ethosfun.com/wp-content/uploads/2019/09/bowl-cuisine-delicious-2067473.jpg",
    image: "https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/roasted-pumpkin-arugula-salad.jpg",
    category: "Breakfast",
    prepTime: "15 min",
    cookTime:  "10 min",
    servings: "4-6",
    tags: [ "magical", "incredible" ],
    ingredients: [ 
      "1 tablespoon TJ’s Soy Sauce",
      "1 tablespoon TJ’s Soyaki Sauce, Stir Fry Sauce, or other tangy marinade you might have sitting in your fridge",
      "1 tsp TJ’s Garlic Powder, if you’ve got it",
      "1/4 cup TJ’s neutral oil (Sunflower, Canola, Grapeseed, etc. will all work here)",
      "1 generous cup any TJ’s Vegetables you might have on hand (green/red/yellow onion, bell peppers, carrots, mushrooms, frozen peas/corn/edamame/broccoli), thawed if frozen, and chopped",
      "3 or 4 cups cooked, day-old TJ’s Rice",
      "2 TJ’s Large Eggs, beaten"
    ],
    steps: [
      "First, you get some stuff. When you're done, then do some stuff with it.",
      "After, it's pretty simple. You take the stuff out of the thing.",
      "Voila, in 3 easy steps you were able to make the thing you wanted to make without doing really anything.",
      "First, you get some stuff. When you're done, then do some stuff with it.",
      "After, it's pretty simple. You take the stuff out of the thing.",
      "Voila, in 3 easy steps you were able to make the thing you wanted to make without doing really anything."
    ]
  );

  /* Layout Constants */
  static const double _PAGE_NAME_FONT_SIZE = 16;
  static const double _TOP_BAR_EDGE_PADDING = 30;

  @override
  Widget build(BuildContext context) {

    return Stack(
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
                    _TopBarButton(
                      icon: Icons.playlist_add,
                      color: StyleSheet.WHITE,
                      size: 30,
                      onTap: () {
                        print('shopping bag');
                      },
                    ),
                    Container(width: 15),
                    _TopBarButton(
                      icon: Icons.favorite_border,
                      color: StyleSheet.WHITE,
                      size: 30,
                      onTap: () {
                        print('favorites');
                      },
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
    );
  }
}

class _TopBarButton extends StatelessWidget {

  final IconData icon;
  final Color color;
  final double size;

  final Future<dynamic> future;
  final Function onTap;

  _TopBarButton({
    @required this.icon, 
    @required this.color, 
    @required this.size,
    @required this.onTap,
    this.future
  });

  @override
  Widget build(BuildContext context) {

    return Button(
      onPressed: onTap,
      child: Container(
        child: Icon(
          icon,
          color: color,
          size: size,
        ),
      ),
    );
  }
}