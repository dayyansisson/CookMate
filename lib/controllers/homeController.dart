import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/backend/backend.dart';

/*
  This file lays out the catalog page controller. 
  
  The controller relies on currentTab, provided by the view, to choose what to display they are ints and go as follows
  0 - The featured tab
  1 - The Favorites tab
  2 - The Today Tab
*/

class HomeController {
  
  //Singleton constuctor
  static final HomeController _homeController = HomeController._internal();

  factory HomeController(){
    return _homeController;
  }

  HomeController._internal();
  
  //Class Variables
  Future<String> imageURL; //Comes from Server Format: JSON This is for the background image
  //int currentTab; //Internal provided to the controller by the view
  List<Recipe> currentRecipeList;
  String headLine; //Server Format: JSON, This is the header for the home page
  String body; //Server Format: JSON
  String title;

  Future<String> getImageURL() async {
    if(currentRecipeList == null){
      return "https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/easy-bolognesey-recipe.jpg";
    }
    return currentRecipeList[0].image;
  }

  /*
    This method returns the displayed recipes 
  */
  Future<List<Recipe>> getRecipes(int currentTab) async {
    
    if(currentTab == 0){
      currentRecipeList = await DB.getFeaturedRecipes();
    }
    else if(currentTab == 1){

      List<Map<String, dynamic>> recipeIDs = await DB.getFavoriteRecipes();

      List<Future<Recipe>> favoriteRecipes = List<Future<Recipe>>(recipeIDs.length);
      for (int i = 0; i < recipeIDs.length; i++) {
       favoriteRecipes[i] = DB.getRecipe(recipeIDs[i]['recipe_id'].toString());
      }

      await Future.wait(favoriteRecipes).then((value) => currentRecipeList = value);

    }
    else if(currentTab == 2){
      currentRecipeList = DB.getTodayRecipes();
    }
    return currentRecipeList;
  }

  /*
    This method returns the correct title of the tab on the home page
  */
  String getTitle(int currentTab){
    if(currentTab == 0){
      title = "Featured";
    }
    else if(currentTab == 1){
      title = "Favorites";
    }
    else if(currentTab == 2){
      title = "Today";
    }
    return title;
  }

  /*
    This method returns the correct header based on the current tab the user is on
  */
  String getHeader(int currentTab){
    if(currentTab == 0){
      headLine = "Featured Meals\nof the Week";
    }
    else if(currentTab == 1){
      headLine = "Your Favorites\nRecipes";
    }
    else if(currentTab == 2){
      headLine = "Today's Meals";
    }
    return headLine;
  }

  /*
    This method returns the correct header based on the current tab the user is on
  */
  String getSubheader(int currentTab){
    if(currentTab == 0){
      //checks to make sure there are at least two elements in the recipe list
      body = "Trader Joes' Featured Recipes!";
        
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