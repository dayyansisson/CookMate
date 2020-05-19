import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/backend/backend.dart';
import 'package:CookMate/provider/recipeModel.dart';
import 'package:flutter/material.dart';

/*
  This file lays out the catalog page controller. 
  
  The controller relies on currentTab, provided by the view, to choose what to display they are ints and go as follows
  0 - The featured tab
  1 - The Favorites tab
  2 - The Today Tab
*/

class HomeController extends ChangeNotifier {

  // Constants
  static const int FEATURED_INDEX = 0;
  static const int FAVORITES_INDEX = 1;
  static const int TODAY_INDEX = 2;

  //Singleton constuctor
  static final HomeController _homeController = HomeController._internal();

  factory HomeController() => _homeController;

  HomeController._internal() {
    
    initRecipeLists();
  }
  
  //Class Variables
  Future<String> imageURL; //Comes from Server Format: JSON This is for the background image
  
  Future<List<Recipe>> featuredRecipes;
  Future<List<Recipe>> favoriteRecipes;

  String headline; //Server Format: JSON, This is the header for the home page
  String body; //Server Format: JSON
  String title;

  Future<String> getImageURL() async {

    return "https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/easy-bolognesey-recipe.jpg";
  }

  void initRecipeLists() {

    featuredRecipes = DB.getFeaturedRecipes();
    updateFavoriteRecipes();
  }

  void updateFavoriteRecipes() async {

    List<Map<String, dynamic>> recipeIDs = await DB.getFavoriteRecipes();
    List<Future<Recipe>> futureRecipes = List<Future<Recipe>>(recipeIDs.length);
    for (int i = 0; i < recipeIDs.length; i++) {
      futureRecipes[i] = DB.getRecipe(recipeIDs[i]['recipe_id'].toString());
    }

    favoriteRecipes = Future.wait(futureRecipes);
    notifyListeners();
  }

  /*
    This method returns the correct title of the tab on the home page
  */
  String getTitle(int currentTab) {

    if(currentTab == FEATURED_INDEX) {
      title = "Featured";
    }
    else if(currentTab == FAVORITES_INDEX) {
      title = "Favorites";
    }
    else if(currentTab == TODAY_INDEX) {
      title = "Today";
    }
    return title;
  }

  /*
    This method returns the correct header based on the current tab the user is on
  */
  String getHeader(int currentTab){
    if(currentTab == FEATURED_INDEX){
      headline = "Featured Meals\nof the Week";
    }
    else if(currentTab == FAVORITES_INDEX){
      headline = "Your Favorites\nRecipes";
    }
    else if(currentTab == TODAY_INDEX){
      headline = "Today's Meals";
    }
    return headline;
  }

  /*
    This method returns the correct header based on the current tab the user is on
  */
  String getSubheader(int currentTab){
    if(currentTab == FEATURED_INDEX){
      //checks to make sure there are at least two elements in the recipe list
      body = "Check out Trader Joes' hand selected featured recipes!";
        
    }
    else if(currentTab == 1){
      body = "All the recipes you've bookmarked for safekeeping.";
    }
    else if(currentTab == 2){
      body = "Let's take a look at what exciting meals you've got planned for today.";
    }
    return body;
  }
}