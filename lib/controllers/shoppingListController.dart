import 'dart:collection';
import 'dart:core';
import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/entities/shoppingIngredient.dart';
import 'package:CookMate/entities/shoppingListRecipe.dart';
import 'package:flutter/material.dart';
import '../backend/backend2.dart';
import '../entities/recipe.dart';
import '../entities/shoppingIngredient.dart';
import '../entities/shoppingListRecipe.dart';

/*
  This file lays out the shopping list page controller. 
*/

class ShoppingListController extends ChangeNotifier {
  //Singleton constuctor
  static final ShoppingListController _shoppingListController =
      ShoppingListController._internal();

  factory ShoppingListController() {
    return _shoppingListController;
  }

  ShoppingListController._internal();

  //Instance list
  Future<List<ShoppingListRecipe>> shoppingList;
  void refreshShoppingList() => shoppingList = _loadShoppingList();

  // Grabs shopping list from database
  Future<List<ShoppingListRecipe>> _loadShoppingList() async {
    List<LinkedHashMap> cart = DB.getShoppingList();

    List<ShoppingListRecipe> slRecipes = List<ShoppingListRecipe>();

    cart.forEach((ingredient) async {
      int recipeID;
      List<ShoppingIngredient> slIng = List<ShoppingIngredient>();

      ingredient.forEach((ing, ingInfo) {
        recipeID = ingInfo['recipe_id'];

        var ing = ShoppingIngredient(
          ingredient: ingInfo['title'],
          purchased: ingInfo['purchased'],
          recipeID: recipeID,
        );
        slIng.add(ing);
      });
      var sl = ShoppingListRecipe(await DB.getRecipeWithID(recipeID), slIng);
      slRecipes.add(sl);
    });

    return slRecipes;
  }

  //This method adds a recipe to the shopping list with the selected ingredients from it
  void addRecipeToShoppingList(Recipe rec) {
    DB.addRecipeToShoppingList(rec.id);
    refreshShoppingList();
    notifyListeners();
  }

  //This method removes a specific recipe from the list
  //Returns true if successfully removed, false otherwise
  void removeRecipeFromList(Recipe rec) async {
    await DB.removeRecipeFromShoppingList(rec.id);
    refreshShoppingList();
    notifyListeners();
  }

  //This method clears all the recipes from the shopping list
  clearAll() async {
    await DB.clearAllFromShoppingList();
    refreshShoppingList();
    notifyListeners();
  }

  //This method marks a specific ingredient as purchased
  //Returns true if successful false otherwise
  Future<void> markPurchased(ShoppingIngredient ing) async {
    //Handle null
    if (ing == null) {
      return;
    }

    await ing.markPurchased();
    refreshShoppingList();
    notifyListeners();
  }

  //This method marks an ingredient as unpurchased
  Future<void> markNotPurchased(ShoppingIngredient ing) async {
    //Handle null
    if (ing == null) {
      return;
    }

    await ing.markNotPurchased();
    refreshShoppingList();
    notifyListeners();
  }
}
