import 'package:CookMate/widgets/pageLayout/mainPage.dart';
import 'package:CookMate/widgets/pageLayout/pageSheet.dart';
import 'package:CookMate/widgets/pageLayout/sheetTab.dart';
import 'package:flutter/material.dart';

class ShoppingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainPage(
      name: 'Shopping List',
      backgroundImage: 'https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/cranberry-orange-cornbread.jpg',
      pageSheet: PageSheet([
        SheetTab(
          name: 'By Recipe', 
          bodyContent: null
        ),
        SheetTab(
          name: 'All Ingredients', 
          bodyContent: null
        ),
      ]),
    );
  }
}
