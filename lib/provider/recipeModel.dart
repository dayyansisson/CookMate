import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/entities/shoppingIngredient.dart';
import 'package:flutter/material.dart';

class RecipePageModel extends ChangeNotifier {
  
  bool _readyForDisplay;

  Recipe _recipe;
  Future<Recipe> _futureRecipe;
  List<ShoppingIngredient> _shoppingIngredients;


  RecipePageModel({Recipe recipe, Future<Recipe> futureRecipe}) : 
    _recipe = recipe, 
    _futureRecipe = futureRecipe, 
    _readyForDisplay = false,
    _shoppingIngredients = List<ShoppingIngredient>();

  bool get isReadyForDisplay => _readyForDisplay;

  void loadRecipeForDisplay() async {

    if(_futureRecipe != null) {
      _recipe = await _futureRecipe;
    }

    List<Future> preloads = [
      _recipe.getIngredients(),
      _recipe.getSteps(),
      _recipe.getTags(),
      _recipe.isFavorite()
    ];

    await Future.wait(preloads);

    _shoppingIngredients = List<ShoppingIngredient>(_recipe.ingredients.length);
    for(int i = 0; i < _recipe.ingredients.length; i++) {
      shoppingIngredients[i] = ShoppingIngredient(_recipe.ingredients[i], purchased: false);
    }

    print('Recipe Model: Recipe loading complete, ready for display.');
    _readyForDisplay = true;
    notifyListeners();
  }

  String get imageURL => _recipe.image;
  String get title => _recipe.title;
  String get description => _recipe.description;
  String get prepTime => _recipe.prepTime;
  String get cookTime => _recipe.cookTime;
  String get servings => _recipe.servings;
  String get category => _recipe.category;
  List<String> get ingredients => _recipe.ingredients;
  List<String> get steps => _recipe.steps;
  List<String> get tags => _recipe.tags;

  bool get isFavorite {

    if(_recipe.favorite == null) {
      _loadFavorite();
    }
    return _recipe.favorite;
  }

  void favorite() async {

    await _recipe.addToFavorites();
    notifyListeners();
  }

  void unfavorite() async {

    await _recipe.removeFromFavorites();
    notifyListeners();
  }

  void _loadFavorite() async {

    await _recipe.isFavorite();
    notifyListeners();
  }

  Recipe get recipe => _recipe;
  List<ShoppingIngredient> get shoppingIngredients => _shoppingIngredients;

}