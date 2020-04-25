import 'package:CookMate/Entities/ingredient.dart';
import 'package:CookMate/Entities/query.dart';
import 'package:CookMate/Entities/recipe.dart';
import 'package:CookMate/backend/backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'dart:collection';
import 'package:quiver/core.dart';
/*
  This file lays out the search page controller. 
*/

class SearchController {

  String imageURL; //Comes from Server Format: JSON
  int currentTab; //Internal 
  List<Query> queries; //Internal 
  //List<Recipe> searchResults; //Internal
  List<String> ingredients;
  List<int> ingredientSearch;

/* 
  This method takes a substring from the view and makes a backend call to find the ingredients
  that match the provided substring

  I can either return a list of ingredients or just strings whichever is better for the view
*/
Future<List<String>> findIngredients(String substring) async {
  //Call to the backend to get a list of strings which are the ingredients that match the substring
  ingredients = await DB.findIngredients(substring);

  if(ingredients == null){
    // TODO something about finding null
  }
  return ingredients;
}

  Future<List<Recipe>> getRecipesFromIngredients(List<String> ing) async {
    //List of recipes that will be returned
    List<Recipe> searchResults;
    
    //Call to backend to get the recipe IDs that match the list of ingredients
    ingredientSearch = await DB.getRecipeWithIngredients(ing);

    if(ingredientSearch == null){
      //TODO handle null
    }

    //Sorts the returned list by id frequency
    ingredientSearch = _sortList(ingredientSearch);

    //Takes the list of recipe ids and returns a list of recipes from them
    searchResults = await _idToObject(ingredientSearch);

    return searchResults;
  }

  Future<List<Recipe>> getRecipesBySubstring(String rec) async {
    List<Recipe> searchResults;

    //Call to the backend with the substring which returns a list of recipe titles that match
    List<int> initialSearch = await DB.findRecipe(rec);

    //Handle null
    if(initialSearch == null){
      //TODO 
    }

    //Takes the list of recipe ids and returns a list of recipes from them
    searchResults = await _idToObject(initialSearch);

    return searchResults;
  }

  //This private method takes a list of recipe ID's and returns the recipe objects for them
  Future<List<Recipe>> _idToObject(List<int> id) async {
    List<Recipe> convert;
    for(int i = 0; i < ingredientSearch.length; i++){
      Recipe rec = await DB.getRecipe(ingredientSearch[i].toString());
      convert.add(rec);
    }
    return convert;
  }

  //This private method takes a list of ints with multiple same entries and returns them 
  //Sorted based on the id frequency
  List<int> _sortList (List<int> ing){
    List<_recipeResult> queue;

    for(int i = 0; i < ing.length; i++){
      _recipeResult id = _recipeResult(ing[i]);

      if(queue.contains(id)){
        int index = queue.indexOf(id);
        queue[index].rank++;
      }
      else{
        queue.add(id);
      }
    }

    //Sorts the list in ascending order
    queue.sort((b,a) => a.rank.compareTo(b.rank));

    //returns the sorted list of ints
    return _resultToList(queue);
  }

  //This private method returns a list of ints from a list of _recipeResult objects
  List<int> _resultToList(List<_recipeResult> lst){
    List<int> toReturn;

    for(int i = 0; i < lst.length; i++){
      toReturn.add(lst[i].recipeID);
    }

    return toReturn;
  }
}
//This private class is used to sort the returned recipes
class _recipeResult extends Object{
  //Variables
  int recipeID;
  int rank = 1;

  _recipeResult(int recipeID){
    this.recipeID = recipeID;
  }



  //Overloads the comparator operation for the priority queue
  bool operator <(_recipeResult other){
    return (this.rank < other.rank);
  }

  //Overloads the == and hashcode methods for the priority queue
  bool operator ==(other){
    return (this.recipeID == other.recipeID);
  }

  int get hashCode => hash2(recipeID.hashCode, rank.hashCode);

}