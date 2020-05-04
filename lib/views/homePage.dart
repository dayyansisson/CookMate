import 'package:CookMate/controllers/homeController.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/page%20layout/mainPage.dart';
import 'package:CookMate/widgets/page%20layout/pageSheet.dart';
import 'package:CookMate/widgets/page%20layout/sheetTab.dart';
import 'package:CookMate/widgets/recipeCardList.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MainPage(
      name: 'Home',
      backgroundImage: StyleSheet.DEFAULT_RECIPE_IMAGE,
      pageSheet: PageSheet([
        SheetTab(
          name: 'Featured',
          title: 'Featured Meals\nof the Week',
          subtitle: 'Something for each part of your day, handpicked just for you!',
          canExpandSheet: true,
          bodyContent: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: RecipeCardList(HomeController().getRecipes(0))
          )
        ),
        SheetTab(
          name: 'Favorites',
          title: 'Your Favorite\nRecipes',
          subtitle: 'All the recipes you\'ve bookmarked for safekeeping',
          canExpandSheet: true,
          bodyContent: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: RecipeCardList(HomeController().getRecipes(1))
          )
        )
      ]),
    );
  }
}