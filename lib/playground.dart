import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/backendTest.dart';
import 'package:CookMate/widgets/page%20layout/mainPage.dart';
import 'package:CookMate/widgets/page%20layout/pageSheet.dart';
import 'package:CookMate/widgets/page%20layout/sheetTab.dart';
import 'package:CookMate/widgets/recipeCard.dart';
import 'package:flutter/material.dart';

/* This class only exists for us to develop different parts of the app 
   without affecting each other's work.
*/
class Playground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: StyleSheet.WHITE,
        body: MainPage(
          name: 'Home',
          pageSheet: PageSheet([
            SheetTab(
                name: "Featured",
                title: "Featured Meals\nof the Week",
                subtitle: "Wild Rice & Eggs, Baked Honey Feta, plus more!",
                bodyGradient: StyleSheet.VERTICAL_GRADIENT_WHITE
                //bodyContent: RecipeCard()
                ),
            SheetTab(
                name: "Favorites",
                title: "Your Favorites\nRecipes",
                subtitle:
                    "All the recipes that you’ve bookmarked for safekeeping.",
                headerContent: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Color(0xFF463300),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Color(0xFF463300),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Color(0xFF463300),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)))),
                    )
                  ],
                )),
            // SheetTab(name: "Today"),
            SheetTab(
                name: "Backend",
                title: "Database test",
                bodyGradient: StyleSheet.VERTICAL_GRADIENT_WHITE,
                bodyContent: BackendTest()),
          ]),
        ));
  }
}
