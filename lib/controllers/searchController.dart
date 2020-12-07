import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/backend/backend2.dart';
import 'package:flutter/material.dart';
/*
  This file lays out the search page controller. 
*/

class SearchController extends ChangeNotifier {
  //Singleton constuctor
  static final SearchController _searchController =
      SearchController._internal();

  factory SearchController() {
    return _searchController;
  }

  SearchController._internal();

  //Instance variables
  List<String> currentIngredients = List<String>();
  Future<List<Recipe>> ingredientSearchResults;
  Future<List<Recipe>> recipeSearchResults;

/* 
  This method takes a substring from the view and makes a backend call to find the ingredients
  that match the provided substring
  I can either return a list of ingredients or just strings whichever is better for the view
*/
  Future<List<String>> findIngredients(String substring) async {
    //Call to the backend to get a list of strings which are the ingredients that match the substring
    List<String> ingredients = await DB.findIngredients(substring);

    if (ingredients == null) {
      print("Found null ingredients.");
      // TODO something about finding null
    }
    return ingredients;
  }

  // Searches db by ingredients
  Future<List<Recipe>> ingredientSearch() async {
    print(currentIngredients);

    //Call to backend to get the recipe IDs that match the list of ingredients
    List<String> ingredientSearchResults =
        await DB.getRecipesWithIngredients(currentIngredients);

    if (ingredientSearchResults == null ||
        ingredientSearchResults.length == 0) {
      //TODO handle null
      print('No Items');
      return null;
    }

    //Sorts the returned list by id frequency
    List<int> ingredientSearch = _sortList(ingredientSearchResults);

    //Takes the list of recipe ids and returns a list of recipes from them
    List<Future<Recipe>> futureResults = List<Future<Recipe>>();
    for (int i = 0; i < ingredientSearch.length; i++) {
      futureResults.add(DB.getRecipeWithID(ingredientSearch[i]));
    }

    return Future.wait(futureResults);
  }

  void addIngredientToSearch(String ing) async {
    //Adds the ingredient to the current search
    currentIngredients.add(ing);
    ingredientSearchResults = ingredientSearch();
    notifyListeners();
  }

  void removeIngredientFromSearch(String ing) async {
    //Adds the ingredient to the current search
    currentIngredients.remove(ing);
    ingredientSearchResults = ingredientSearch();
    notifyListeners();
  }

  Future<List<Recipe>> recipeSearch(String rec) async {
    //Call to the backend with the substring which returns a list of recipe titles that match
    List<int> initialSearch = await DB.findRecipe(rec);

    //Handle null
    if (initialSearch == null) {
      //TODO
    }

    //Takes the list of recipe ids and returns a list of recipes from them
    List<Future<Recipe>> futureResults = List<Future<Recipe>>();
    for (int i = 0; i < initialSearch.length; i++) {
      futureResults.add(DB.getRecipeWithID(initialSearch[i]));
    }

    return Future.wait(futureResults);
  }

  void getRecipesBySubstring(String rec) {
    recipeSearchResults = recipeSearch(rec);
    notifyListeners();
  }

  //This private method takes a list of ints with multiple same entries and returns them
  //Sorted based on the id frequency
  List<int> _sortList(List<String> ing) {
    List<_RecipeResult> queue = List<_RecipeResult>();
    for (int i = 0; i < ing.length; i++) {
      _RecipeResult id = _RecipeResult(int.parse(ing[i]));

      if (queue.contains(id)) {
        int index = queue.indexOf(id);
        queue[index].incrementRank();
      } else {
        queue.add(id);
      }
    }

    //Sorts the list in ascending order
    queue.sort((b, a) => a.rank.compareTo(b.rank));

    //returns the sorted list of ints
    return _resultToList(queue);
  }

  //This private method returns a list of ints from a list of _recipeResult objects
  List<int> _resultToList(List<_RecipeResult> lst) {
    List<int> toReturn = List<int>();

    for (int i = 0; i < lst.length; i++) {
      toReturn.add(lst[i].recipeID);
    }

    return toReturn;
  }
}

//This private class is used to sort the returned recipes
class _RecipeResult {
  //Variables
  int recipeID;
  int rank = 1;

  _RecipeResult(int recipeID) {
    this.recipeID = recipeID;
  }

  //Increments the ranking
  void incrementRank() {
    this.rank = this.rank + 1;
  }

  //Overloads the comparator operation for the priority queue
  bool operator <(_RecipeResult other) {
    return (this.rank < other.rank);
  }

  //Overloads the == and hashcode methods for the priority queue
  bool operator ==(Object other) =>
      other is _RecipeResult && other.recipeID == this.recipeID;

  int get hashCode => recipeID.hashCode;
  //int get hashCode => hash2(recipeID.hashCode, rank.hashCode);

}
