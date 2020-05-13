import 'package:CookMate/controllers/homeController.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/pageLayout/mainPage.dart';
import 'package:CookMate/widgets/pageLayout/pageSheet.dart';
import 'package:CookMate/widgets/pageLayout/sheetTab.dart';
import 'package:CookMate/widgets/recipeCardList.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainPage(
      name: 'Home',
      backgroundImage: StyleSheet.DEFAULT_RECIPE_IMAGE,
      pageSheet: PageSheet.builder(
        tabCount: 3,
        builder: (currentTab) {
          return SheetTab(
            name: HomeController().getTitle(currentTab),
            header: HomeController().getHeader(currentTab),
            subheader: HomeController().getSubheader(currentTab),
            canExpandSheet: true,
            bodyContent: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: RecipeCardList(HomeController().getRecipes(currentTab)),
            )
          );
        },
      )
    );
  }
}
