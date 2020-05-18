import 'package:CookMate/entities/entity.dart';
import 'package:flutter/material.dart';
import 'package:CookMate/backend/backend.dart';

/*
  This file lays out the shopping ingredient class. 
*/

class ShoppingIngredient extends Entity {

  int recipeID;
  bool purchased;
  String ingredient;

  ShoppingIngredient({
    @required this.ingredient,
    @required this.purchased,
    @required this.recipeID,
  });

  Future<void> markPurchased() async {
    
    if (purchased) {
      return;
    }
    
    this.purchased = true;
    await DB.updateShoppingListItem(recipeID, this);
  }

  Future<void> markNotPurchased() async {

    if (!purchased) {
      return;
    }

    this.purchased = false;
    await DB.updateShoppingListItem(recipeID, this);
  }

  // Returns a JSON version
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'recipe_id': recipeID,
      'item': ingredient,
      'purchased': purchased ? 1 : 0,
    };
    return map;
  }

  // Returns a Recipe object from a map
  static ShoppingIngredient fromMap(Map<String, dynamic> map) {
    return ShoppingIngredient(
      recipeID: map['recipe_id'],
      purchased: map['purchased'] == 1 ? true : false,
      ingredient: map['item'],
    );
  }
}
