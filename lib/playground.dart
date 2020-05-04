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
  }
}