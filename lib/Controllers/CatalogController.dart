
import 'dart:math';
import 'package:CookMate/Enums/category.dart';
import 'package:CookMate/backend/backend.dart';
import 'package:CookMate/Entities/query.dart';
import 'package:CookMate/Entities/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

