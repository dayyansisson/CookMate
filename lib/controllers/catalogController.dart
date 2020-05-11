import 'dart:math';
import 'package:CookMate/enums/category.dart';
import 'package:CookMate/backend/backend.dart';
import 'package:CookMate/entities/recipe.dart';

/*
  This file lays out the catalog page controller. 
  The controller relies on currentTab, provided by the view, to choose what to display they are ints and go as follows
  0 - The appetizer tab
  1 - The beverage tab
  2 - The breakfast tab
  3 - The Lunch Tab
  4 - The Dinner Tab
  5 - The desserts tab
*/

class CatalogController {

  /* Constants */
  static const int APPETIZERS = 0;
  static const int BEVERAGE = 1;
  static const int BREAKFAST = 2;
  static const int LUNCH = 3;
  static const int DINNER = 4;
  static const int DESSERTS = 5;
  static const int NUMBER_OF_CATEGORIES = 6;

  //Singleton constuctor
  static final CatalogController _catalogController = CatalogController._internal();

  factory CatalogController(){
    return _catalogController;
  }

  CatalogController._internal();

  //Class variables
  String imageURL; //Comes from Server Format: JSON
  //int currentTab; //Internal provided to the controller by the view
  List<Recipe> currentRecipeList; //Local DB/Server Format: JSON
  //DB _backend;

  String getTitle(int currentTab) {

    String title;
    switch(currentTab) {
      case APPETIZERS: title = 'Appetizers'; break;
      case BEVERAGE: title = 'Beverage'; break;
      case BREAKFAST: title = 'Breakfast'; break;
      case LUNCH: title = 'Lunch'; break;
      case DINNER: title = 'Dinner'; break;
      case DESSERTS: title = 'Desserts'; break;
    }

    return title;
  }

  //Get recipe method
  //Call this method when the view updates, this updates the displayed recipes and the image that is displayed
  Future<List<Recipe>> getRecipes(int currentTab) async {
    //Based on current tab make call 
    if(currentTab == 0){
      currentRecipeList = await DB.getRecipesByCategory(Category.appetizers);
    }
    else if (currentTab == 1){
      currentRecipeList = await DB.getRecipesByCategory(Category.beverages);
    }
    else if(currentTab == 2){
      currentRecipeList = await DB.getRecipesByCategory(Category.breakfast);
    }
    else if(currentTab == 3){
      currentRecipeList = await DB.getRecipesByCategory(Category.lunch);
    }
    else if(currentTab == 4){
      currentRecipeList = await DB.getRecipesByCategory(Category.dinner);
    }
    else if(currentTab == 5){
      currentRecipeList = await DB.getRecipesByCategory(Category.desserts);
    }
    return currentRecipeList;
  }

  //This method returns the background image url from a randomly selected recipe in the current recipe list
  String getImageURL(){
    imageURL = currentRecipeList[Random().nextInt(currentRecipeList.length-1)].image;
    return imageURL;
  }
}