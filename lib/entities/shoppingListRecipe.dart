import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/entities/shoppingIngredient.dart';

class shoppingListRecipe{
  //Variables
  String recipeTitle;
  List<ShoppingIngredient> ing;

  //Constructor
  shoppingListRecipe(Recipe rec, List<ShoppingIngredient> ing){
    recipeTitle = rec.title;
    this.ing = ing;
  }

  shoppingListRecipe.fromRec(Recipe rec) {
    recipeTitle = rec.title;
    this.ing == null;
  }

  //This method returns the list of shopping ingredients
  List<ShoppingIngredient> getIngredients() => this.ing;

  //This method returns the recipe title'
  String getTitle() => this.recipeTitle;

  //Overloads the == and hashcode methods for the contains method
  bool operator ==(Object other) => other is shoppingListRecipe && other.recipeTitle == this.recipeTitle;

  int get hashCode => recipeTitle.hashCode;

}