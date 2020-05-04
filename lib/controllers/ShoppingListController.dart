import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/entities/shoppingIngredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
  This file lays out the shopping list page controller. 
*/

class ShoppingListController {

  String imageURL; //Comes from Server Format: JSON
  int currentTab; //Internal 
  List<Recipe> searchResults; //Internal

  //Singleton constuctor
  static final ShoppingListController _shoppingListController = ShoppingListController._internal();

  factory ShoppingListController(){
    return _shoppingListController;
  }

  ShoppingListController._internal();

  //Class Methods

  //This method adds a recipe to the shopping list with the selected ingredients from it
  bool addRecipeToShoppingList(Recipe rec, List<ShoppingIngredient> ingr){

    return false;
  }

  bool removeRecipeFromList(Recipe rec){

  }


}