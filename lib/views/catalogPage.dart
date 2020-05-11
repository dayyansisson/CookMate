import 'package:CookMate/controllers/catalogController.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/pageLayout/mainPage.dart';
import 'package:CookMate/widgets/pageLayout/pageSheet.dart';
import 'package:CookMate/widgets/pageLayout/sheetTab.dart';
import 'package:CookMate/widgets/recipeCardList.dart';
import 'package:flutter/material.dart';

class CatalogPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MainPage(
      name: 'Catalog',
      backgroundImage: StyleSheet.DEFAULT_RECIPE_IMAGE,
      pageSheet: PageSheet.builder(
        tabCount: CatalogController.NUMBER_OF_CATEGORIES,
        builder: (currentTab) {
          return SheetTab(
            name: CatalogController().getTitle(currentTab),
            bodyContent: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: RecipeCardList(CatalogController().getRecipes(currentTab)),
            )
          );
        },
      )
    );
  }
}
