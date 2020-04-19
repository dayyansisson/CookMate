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