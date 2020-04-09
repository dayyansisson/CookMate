import 'dart:math';

import 'package:CookMate/Entities/query.dart';
import 'package:CookMate/Entities/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
  This file lays out the catalog page controller. 
  
  The controller relies on currentTab, provided by the view, to choose what to display they are ints and go as follows
  0 - The featured tab
  1 - The Favorites tab
  2 - The Today Tab
*/

class CatalogController {

  String imageURL; //Comes from Server Format: JSON This is for the background image
  //int currentTab; //Internal provided to the controller by the view
  List<Recipe> currentRecipeList;
  String headLine; //Server Format: JSON, This is the header for the home page
  String body; //Server Format: JSON

  String getImageURL(){
    return currentRecipeList[0].imageURL;
  }

  /*
    This method returns the displayed recipes 
  */
  List<Recipe> getRecipe(int currentTab){
    if(currentTab == 0){
      currentRecipeList = backend.getFeaturedRecipes();
    }
    else if(currentTab == 1){
      currentRecipeList = backend.getFavoriteRecipes();
    }
    else if(currentTab == 2){
      currentRecipeList == backend.getTodayRecipes();
    }
    return currentRecipeList;
  }

  /*
    This method returns the correct header based on the current tab the user is on
  */
  String getHeader(int currentTab){
    if(currentTab == 0){
      headLine = 'Featured Meals of the Week';
    }
    else if(currentTab == 1){
      headLine = 'Your Favorite Recipes';
    }
    else if(currentTab == 2){
      headLine = "Today's Meals";
    }
    return headLine;
  }

  /*
    This method returns the correct header based on the current tab the user is on
  */
  String getBody(int currentTab){
    if(currentTab == 0){
      //checks to make sure there are at least two elements in the recipe list
      if(currentRecipeList.length >= 2){
        String title_1 = currentRecipeList[0].title;
        String title_2 = currentRecipeList[1].title;
        body = "$title_1, $title_2, plus more!";
      }
      else if(currentRecipeList.length == 1){
        String title_1 = currentRecipeList[0].title;
        body = "$title_1";
      }
      else{
        body = '';
      }
        
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