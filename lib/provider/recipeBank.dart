import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/provider/recipeModel.dart';

class RecipeModelBank {
  
  // Singleton constuctor
  static final RecipeModelBank _instance = RecipeModelBank._internal();
  factory RecipeModelBank() => _instance;
  RecipeModelBank._internal() : _recipeModels = Map<int, RecipeModel>();

  // Bank of recipe models accessible by recipe id
  final Map<int, RecipeModel> _recipeModels;

  // Adds model to bank if it doesn't exist
  RecipeModel getModel(Recipe recipe) => _recipeModels.putIfAbsent(recipe.id, () => RecipeModel(recipe));
}