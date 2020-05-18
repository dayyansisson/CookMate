import 'dart:core';
import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/entities/shoppingIngredient.dart';
import 'package:CookMate/entities/shoppingListRecipe.dart';
import 'package:flutter/material.dart';
import '../backend/backend.dart';
import '../entities/recipe.dart';
import '../entities/shoppingIngredient.dart';

/*
  This file lays out the shopping list page controller. 
*/

class ShoppingListController extends ChangeNotifier{

  //Singleton constuctor
  static final ShoppingListController _shoppingListController = ShoppingListController._internal();

  factory ShoppingListController(){
    return _shoppingListController;
  }

  ShoppingListController._internal();


  //Instance list
  Future<List<ShoppingListRecipe>> shoppingList;
  void refreshShoppingList() => shoppingList = _loadShoppingList();

  // Grabs shopping list from database
  Future<List<ShoppingListRecipe>> _loadShoppingList() async {

    List<Map<String, dynamic>> results = await DB.getShoppingList();
    List<int> ids = List<int>();
    
    // Grab list of recipe ids
    for(Map<String, dynamic> item in results) {
      int id = item['recipe_id'];
      if(!ids.contains(id)) {
        ids.add(id);
      }
    }

    List<Future<List<ShoppingIngredient>>> futureIngredients = List<Future<List<ShoppingIngredient>>>();
    List<Future<Recipe>> futureRecipes = List<Future<Recipe>>();
    for(int id in ids) {
      futureIngredients.add(DB.getShoppingListByRecipe(id));
      futureRecipes.add(DB.getRecipe(id.toString()));
    }

    List<List<ShoppingIngredient>> ingredients = await Future.wait(futureIngredients);
    List<Recipe> recipes = await Future.wait(futureRecipes);

    if(ingredients.length != recipes.length) {
      print('THIS IS ABOUT TO BE A PROBLEM');
    }

    List<ShoppingListRecipe> slRecipes = List<ShoppingListRecipe>(recipes.length);
    for(int i = 0; i < recipes.length; i++) {
      ShoppingListRecipe slr = ShoppingListRecipe(recipes[i], ingredients[i]);
      slRecipes[i] = slr;
    }

    print("Refreshed shopping list: Size(${slRecipes.length})");
    return slRecipes;
  }

  //This method adds a recipe to the shopping list with the selected ingredients from it
  void addRecipeToShoppingList(Recipe rec, List<ShoppingIngredient> ingr) async {

    await DB.addRecipeToShoppingList(rec.id, ingr);
    refreshShoppingList();
    notifyListeners();
  }

  //This method removes a specific recipe from the list
  //Returns true if successfully removed, false otherwise
  void removeRecipeFromList(Recipe rec) async {

    print("Initiated: removeRecipeFromList");

    await DB.removeRecipeFromShoppingList(rec.id);
    refreshShoppingList();
    notifyListeners();

    print("Completed: removeRecipeFromList");
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
    if(ing == null){
      return;
    }

    await ing.markPurchased();
    refreshShoppingList();
    notifyListeners();
  }

  //This method marks an ingredient as unpurchased
  Future<void> markNotPurchased(ShoppingIngredient ing) async {
    
    //Handle null
    if(ing == null){
      return;
    }
    
    await ing.markNotPurchased();
    refreshShoppingList();
    notifyListeners();
  }
}