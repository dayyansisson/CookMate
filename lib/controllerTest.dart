
import 'package:CookMate/controllers/shoppingListController.dart';
import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/entities/shoppingIngredient.dart';

import 'backend/backend.dart';

void main () async {
  await DB.init();
  Recipe rec = await DB.getRecipe('1');
  List<ShoppingIngredient> ing = List<ShoppingIngredient>();
  ShoppingListController shopping;
  
  for(int i = 0; i < rec.ingredients.length; i ++){
    ing.add(ShoppingIngredient(ingredient: rec.ingredients[i], purchased: false, recipeID: rec.id));
  }

  shopping.addRecipeToShoppingList(rec, ing);

  print(shopping.shoppingList);
  print('here');
}