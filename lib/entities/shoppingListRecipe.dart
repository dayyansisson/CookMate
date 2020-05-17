import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/entities/shoppingIngredient.dart';
class ShoppingListRecipe {
  //Variables
  Recipe recipe;
  List<ShoppingIngredient> ing;

  //Constructor
  ShoppingListRecipe(Recipe rec, List<ShoppingIngredient> ing){
    recipe = rec;
    this.ing = ing;
  }
  ShoppingListRecipe.fromRec(Recipe rec) {
    recipe = rec;
  }
  
  //This method returns the list of shopping ingredients
  List<ShoppingIngredient> getIngredients() => this.ing;

  //Overloads the == and hashcode methods for the contains method
  bool operator ==(Object other) => other is ShoppingListRecipe && other.recipe == this.recipe;
  int get hashCode => recipe.hashCode;
}