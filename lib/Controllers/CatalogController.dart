import 'package:CookMate/Entities/query.dart';
import 'package:CookMate/Entities/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
  This file lays out the catalog page controller. 
*/

class CatalogController {

  String imageURL; //Comes from Server Format: JSON
  int currentTab; //Internal 
  List<Recipe> fullRecipeList; //Local DB/Server Format: JSON

}