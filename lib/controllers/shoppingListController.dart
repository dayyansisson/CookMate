import 'dart:core';
import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/entities/shoppingIngredient.dart';
import '../backend/backend.dart';
import '../entities/recipe.dart';
import '../entities/shoppingIngredient.dart';
import '../entities/shoppingIngredient.dart';
import '../entities/shoppingIngredient.dart';

/*
  This file lays out the shopping list page controller. 
*/

class ShoppingListController {

  //Singleton constuctor
  static final ShoppingListController _shoppingListController = ShoppingListController._internal();

  factory ShoppingListController(){
    return _shoppingListController;
  }

  //Instance list
  List<_shoppingListRecipe> shoppingList = List<_shoppingListRecipe>();

  ShoppingListController._internal();

  //Class Methods

  //This method adds a recipe to the shopping list with the selected ingredients from it
  bool addRecipeToShoppingList(Recipe rec, List<ShoppingIngredient> ingr){
    //Check for null
    if(rec == null || ingr == null){
      return false;
    }

    if(!shoppingList.contains(_shoppingListRecipe(rec,ingr))){
      //return false if already in the list
      return false;
    } else{
      //Database call to update
      DB.addRecipeToShoppingList(rec, ingr);

      //Update Controller List
      shoppingList.add(_shoppingListRecipe(rec, ingr));

      //return true if added
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
    if(!shoppingList.contains(_shoppingListRecipe.fromRec(rec))){
      //if item is not present return false
      return false;
    } else{
      //Remove from local list and DB
      shoppingList.remove(_shoppingListRecipe.fromRec(rec));
      DB.removeRecipeFromList(rec);

      //Return true if successfully removed
      return true;
    }
  }

  //This method clears all the recipes from the shopping list
  clearAll(){
    shoppingList.clear();
    DB.clearAllFromShoppingList();
  }

  //This method marks a specific ingredient as purchased
  //Returns true if successful false otherwise
  bool markPurchased(Recipe rec, ShoppingIngredient ing){
    //Handle null
    if(rec == null || ing == null){
      return false;
    }
    
    //Check if list contains the rec
    if(!shoppingList.contains(_shoppingListRecipe.fromRec(rec))){
      //if item is not present return false
      return false;
    } else{
      //Mark as purchased in list and update DB
      List<ShoppingIngredient> ingredients = shoppingList[shoppingList.indexOf(_shoppingListRecipe.fromRec(rec))].ing;
      
      //Checks if the ingredient has already been marked as purchased
      if(ingredients[ingredients.indexOf(ing)] == true){
        return false;
      }
      else{
        ingredients[ingredients.indexOf(ing)].purchased = true;
        DB.markPurchased(rec);

        //Return true if sucessful
        return true;
      }
    }
  }

}

class _shoppingListRecipe{
  //Variables
  String recipeTitle;
  List<ShoppingIngredient> ing;

  //Constructor
  _shoppingListRecipe(Recipe rec, List<ShoppingIngredient> ing){
    recipeTitle = rec.title;
    this.ing = ing;
  }

  _shoppingListRecipe.fromRec(Recipe rec) {
    recipeTitle = rec.title;
    this.ing == null;
  }

  //Overloads the == and hashcode methods for the contains method
  bool operator ==(Object other) => other is _shoppingListRecipe && other.recipeTitle == this.recipeTitle;

  int get hashCode => recipeTitle.hashCode;

}