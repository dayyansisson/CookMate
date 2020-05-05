import 'package:CookMate/entities/recipe.dart';

/*
  This file lays out the ingredient class. 
*/

class Ingredient {
  static String table = 'ingredient';

  String name;
  int quantity;
  String units;
  List<Recipe> associatedRecipes;
  bool query;

  //Everything from the server below

}
