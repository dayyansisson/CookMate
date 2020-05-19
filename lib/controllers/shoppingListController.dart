import 'dart:core';
import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/entities/shoppingIngredient.dart';
import 'package:CookMate/entities/shoppingListRecipe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../backend/backend.dart';
import '../entities/recipe.dart';
import '../entities/shoppingIngredient.dart';
import '../entities/shoppingIngredient.dart';
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

  //Instance list
  List<ShoppingListRecipe> shoppingList = List<ShoppingListRecipe>();

  ShoppingListController._internal();

  //Class Methods

  //This method adds a recipe to the shopping list with the selected ingredients from it
  bool addRecipeToShoppingList(Recipe rec, List<ShoppingIngredient> ingr){
    //TODO test that this always works
    //Check for null
    if(rec == null || ingr == null){
      return false;
    }

    if(!shoppingList.contains(ShoppingListRecipe(rec,ingr))){
      //return false if already in the list
      return false;
    } else{
      //Database call to update
      DB.addRecipeToShoppingList(rec.id, ingr);

      //Update Controller List
      shoppingList.add(ShoppingListRecipe(rec, ingr));

      //return true if added
      notifyListeners();
      return true;
    }
  }

  //This method removes a specific recipe from the list
  //Returns true if successfully removed, false otherwise
  bool removeRecipeFromList(Recipe rec){
    //Check for null
    if(rec == null){
      return false;
    }

    //Check if list contains the rec
    if(!shoppingList.contains(ShoppingListRecipe.fromRec(rec))){
      //if item is not present return false
      return false;
    } else{
      //Remove from local list and DB
      shoppingList.remove(ShoppingListRecipe.fromRec(rec));
      DB.removeRecipeFromShoppingList(rec.id);

      //Return true if successfully removed
      notifyListeners();
      return true;
    }
  }

  //This method clears all the recipes from the shopping list
  clearAll(){
    shoppingList.clear();
    DB.clearAllFromShoppingList();
    notifyListeners();
  }

  //This method marks a specific ingredient as purchased
  //Returns true if successful false otherwise
  bool markPurchased(Recipe rec, ShoppingIngredient ing){
    //Handle null
    if(rec == null || ing == null){
      return false;
    }
    
    //Check if list contains the rec
    if(!shoppingList.contains(ShoppingListRecipe.fromRec(rec))){
      //if item is not present return false
      return false;
    } else{
      //Mark as purchased in list and update DB
      List<ShoppingIngredient> ingredients = getShoppingIngredients(rec);
      
      //Checks if the ingredient has already been marked as purchased
      if(purchased(ingredients, ing)){
        return false;
      }
      else{
        ingredients[ingredients.indexOf(ing)].markPurchased();

        //Return true if sucessful
        notifyListeners();
        return true;
      }
    }
  }

  //This method marks an ingredient as unpurchased
  bool markNotPurchased(Recipe rec, ShoppingIngredient ing){
    //Handle null
    if(rec == null || ing == null){
      return false;
    }
    
    //Check if list contains the rec
    if(!shoppingList.contains(ShoppingListRecipe.fromRec(rec))){
      //if item is not present return false
      return false;
    } else{
      //Mark as purchased in list and update DB
      List<ShoppingIngredient> ingredients = getShoppingIngredients(rec);
      
      //Checks if the ingredient has already been marked as purchased
      if(!purchased(ingredients, ing)){
        return false;
      }
      else{
        ingredients[ingredients.indexOf(ing)].markNotPurchased();

        //Return true if sucessful
        notifyListeners();
        return true;
      }
    }

    //This method returns the list of ShoppingListRecipes to the view
    Future<List<ShoppingListRecipe>> getShoppingList(){
      
    }
  }

  //This method gets the ingredients for a specific recipe
  List<ShoppingIngredient> getShoppingIngredients(Recipe rec) => shoppingList[shoppingList.indexOf(ShoppingListRecipe.fromRec(rec))].getIngredients();

  //This method checks if an ingredient has been purchased
  bool purchased(List<ShoppingIngredient> ingredients, ShoppingIngredient ing) => ingredients[ingredients.indexOf(ing)].purchased;
}

