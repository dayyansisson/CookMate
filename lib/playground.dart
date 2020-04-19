import 'package:CookMate/Entities/recipe.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/page%20layout/mainPage.dart';
import 'package:CookMate/widgets/page%20layout/pageSheet.dart';
import 'package:CookMate/widgets/page%20layout/sheetTab.dart';
import 'package:CookMate/widgets/recipeCard.dart';
import 'package:flutter/material.dart';
import 'package:CookMate/Controllers/HomeController.dart';

import 'Controllers/CatalogController.dart';

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
          backgroundImage: "https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/easy-bolognesey-recipe.jpg",
          pageSheet: PageSheet([
            SheetTab(
                name: HomeController().getTitle(0),
                title: HomeController().getHeader(0),
                subtitle: HomeController().getBody(0),
                bodyGradient: StyleSheet.VERTICAL_GRADIENT_WHITE,
                canExpandSheet: true,
                futureBackground: HomeController().getImageURL(),
                bodyContent: Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 10),
                    child: FutureBuilder(
                      future: CatalogController().getRecipes(0),
                      builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if(snapshot.data == null){
                          print(snapshot.data.length);
                          print('bad return');
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return RecipeCard(snapshot.data[index]);
                          },
                        );
                      },
                    ))),
            SheetTab(
              name: HomeController().getTitle(1),
              title: HomeController().getHeader(1),
              futureBackground:
                 HomeController().getImageURL(),
              subtitle:
                  HomeController().getBody(1),
              canExpandSheet: true,
              bodyContent: Column(
                children: <Widget>[
                  Container(
                    color: StyleSheet.WHITE,
                    child: Row(
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
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: FutureBuilder(
                          future: CatalogController().getRecipes(1),
                          builder:
                              (context, AsyncSnapshot<List<Recipe>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return RecipeCard(snapshot.data[index]);
                              },
                            );
                          },
                        )),
                  )
                ],
              ),
            ),
            SheetTab(name: "Today", bodyContent: null),
          ]),
        ));
  }
}
