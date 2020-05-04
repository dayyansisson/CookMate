import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/page%20layout/mainPage.dart';
import 'package:CookMate/widgets/page%20layout/pageSheet.dart';
import 'package:flutter/material.dart';

class CatalogPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return MainPage(
      name: 'Catalog',
      backgroundImage: StyleSheet.DEFAULT_RECIPE_IMAGE,
      pageSheet: PageSheet([
          
      ]),
    );
  }
}