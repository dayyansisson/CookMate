import 'package:flutter/material.dart';

/*
  This file lays out the shopping ingredient class. 
*/

class ShoppingIngredient {
  
  bool purchased;
  String ingredient;

  ShoppingIngredient(this.ingredient, { @required this.purchased });
}