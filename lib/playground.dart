import 'package:CookMate/backend/backend.dart';
import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/page%20layout/driver.dart';
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

    return Driver();

    // return Scaffold(
    //   backgroundColor: StyleSheet.WHITE,
    //   body: MainPage(
    //     name: 'Home',
    //     backgroundImage: "https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/cranberry-orange-cornbread.jpg",
    //     pageSheet: PageSheet([
    //       SheetTab(
    //         name: "Featured",     
    //         title: "Featured Meals\nof the Week",
    //         subtitle: "Wild Rice & Eggs, Baked Honey Feta, plus more!",
    //         bodyGradient: StyleSheet.VERTICAL_GRADIENT_WHITE,
    //         canExpandSheet: true,
    //         bodyContent: Padding(
    //           padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
    //           child: FutureBuilder<Recipe>(
    //             future: DB.getRecipe('100'),
    //             builder: (context, snapshot) {
    //               if(snapshot.hasData) {
    //                 return RecipeCard(snapshot.data);
    //               }

    //               return Center(child: CircularProgressIndicator());
    //             },
    //           )
    //         )
    //       ),
    //     ]),
    //   )
    // );
  }
}