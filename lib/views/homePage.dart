import 'package:CookMate/controllers/homeController.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/pageLayout/mainPage.dart';
import 'package:CookMate/widgets/pageLayout/pageSheet.dart';
import 'package:CookMate/widgets/pageLayout/sheetTab.dart';
import 'package:CookMate/widgets/recipeCardList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainPage(
      name: 'Home',
      backgroundImage: StyleSheet.DEFAULT_RECIPE_IMAGE,
      pageSheet: PageSheet([
        SheetTab(   // Featured
          name: HomeController().getTitle(HomeController.FEATURED_INDEX),
          header: HomeController().getHeader(HomeController.FEATURED_INDEX),
          subheader: HomeController().getSubheader(HomeController.FEATURED_INDEX),
          backgroundImage: 'https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/poached-egg-latkes.jpg',
          canExpandSheet: true,
          bodyContent: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: RecipeCardList(HomeController().featuredRecipes),
          )
        ),
        SheetTab(   // Favorites
          name: HomeController().getTitle(HomeController.FAVORITES_INDEX),
          header: HomeController().getHeader(HomeController.FAVORITES_INDEX),
          subheader: HomeController().getSubheader(HomeController.FAVORITES_INDEX),
          backgroundImage: 'https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/tofu-fries.jpg',
          canExpandSheet: true,
          bodyContent: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ChangeNotifierProvider.value(
              value: HomeController(),
              child: Consumer<HomeController>(
                builder: (context, controller, _) {
                  return RecipeCardList(HomeController().favoriteRecipes);
                },
              )
            ),
          )
        ),
        SheetTab(   // Today
          name: HomeController().getTitle(HomeController.TODAY_INDEX),
          header: HomeController().getHeader(HomeController.TODAY_INDEX),
          subheader: HomeController().getSubheader(HomeController.TODAY_INDEX),
          backgroundImage: 'https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/tempeh-thai-peanut-salad.jpg',
          canExpandSheet: true,
          bodyContent: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * (2/3),
              child: Text(
                'Ah no! Looks like you don’t have a calendar. But if you did, this is where all your planned recipes would show up.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: StyleSheet.GREY,
                  fontSize: 18,
                  height: 1.2
                ),
              ),
            ),
          )
        ),
      ])
    );
  }
}
