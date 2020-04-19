import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/views/recipePage.dart';
import 'package:flutter/material.dart';

/* This class only exists for us to develop different parts of the app 
   without affecting each other's work.
*/
class Playground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleSheet.WHITE,
      body: RecipePage(),
      // body: MainPage(
      //   name: 'Home',
      //   backgroundImage: "https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/cranberry-orange-cornbread.jpg",
      //   pageSheet: PageSheet([
      //     SheetTab(
      //       name: "Featured",     
      //       title: "Featured Meals\nof the Week",
      //       subtitle: "Wild Rice & Eggs, Baked Honey Feta, plus more!",
      //       bodyGradient: StyleSheet.VERTICAL_GRADIENT_WHITE,
      //       canExpandSheet: true,
      //       bodyContent: Padding(
      //         padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
      //         child: ListView(
      //           children: <Widget>[
      //             RecipeCard(),
      //             RecipeCard()
      //           ],
      //         ),
      //       )
      //     ),
      //     SheetTab(
      //       name: "Favorites",
      //       title: "Your Favorites\nRecipes",
      //       backgroundImage: "https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/easy-bolognesey-recipe.jpg",
      //       subtitle: "All the recipes that you’ve bookmarked for safekeeping.",
      //       canExpandSheet: true,
      //       bodyContent: Column(
      //         children: <Widget>[
      //           Container(
      //             color: StyleSheet.WHITE,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: <Widget>[
      //                 Padding(
      //                   padding: const EdgeInsets.all(15),
      //                   child: Container(
      //                     height: 35,
      //                     width: 80,
      //                     decoration: BoxDecoration(
      //                       color: Color(0xFF463300),
      //                       borderRadius: BorderRadius.all(Radius.circular(50)) 
      //                     )
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.all(15),
      //                   child: Container(
      //                     height: 35,
      //                     width: 80,
      //                     decoration: BoxDecoration(
      //                       color: Color(0xFF463300),
      //                       borderRadius: BorderRadius.all(Radius.circular(50)) 
      //                     )
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.all(15),
      //                   child: Container(
      //                     height: 35,
      //                     width: 80,
      //                     decoration: BoxDecoration(
      //                       color: Color(0xFF463300),
      //                       borderRadius: BorderRadius.all(Radius.circular(50)) 
      //                     )
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //           Expanded(
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 25),
      //               child: ListView(
      //                 children: <Widget>[
      //                   RecipeCard(),
      //                   RecipeCard()
      //                 ],
      //               )
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //     SheetTab(name: "Today", bodyContent: null),
      //   ]),
      // )
    );
  }
}
