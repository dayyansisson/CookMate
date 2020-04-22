import 'package:CookMate/Entities/ingredient.dart';
import 'package:CookMate/Entities/query.dart';
import 'package:CookMate/Entities/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
  This file lays out the search page controller. 
*/

class SearchController {

  String imageURL; //Comes from Server Format: JSON
  int currentTab; //Internal 
  List<Query> queries; //Internal 
  List<Recipe> searchResults; //Internal

}
/* 
  This method takes a substring from the view and makes a backend call to find the ingredients
  that match the provided substring

  I can either return a list of ingredients or just strings whichever is better for the view
*/
Future<List<Ingredient>> findIngredients(String substring) async {

  

}