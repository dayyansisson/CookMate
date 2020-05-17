import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/entities/shoppingIngredient.dart';
import 'package:CookMate/entities/shoppingListRecipe.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/checkbox.dart';
import 'package:CookMate/widgets/pageLayout/mainPage.dart';
import 'package:CookMate/widgets/pageLayout/pageSheet.dart';
import 'package:CookMate/widgets/pageLayout/sheetTab.dart';
import 'package:flutter/material.dart';

class ShoppingListPage extends StatelessWidget {

  final List<ShoppingListRecipe> shoppingList = [
    ShoppingListRecipe(
      Recipe(title: 'Sriracha Furikake Tofu Fries'),
      [
        ShoppingIngredient("TJ's Canola Oil Spray", purchased: false),
        ShoppingIngredient("2 packages TJ's Sriracha Flavored Baked Tofu", purchased: false),
        ShoppingIngredient("2 large TJ's Eggs, egg whites separated", purchased: false),
        ShoppingIngredient("3/4 cup TJ's Panko Breadcrumbs", purchased: false),
        ShoppingIngredient("1/4 cup TJ's Grated Parmesan Cheese", purchased: false),
        ShoppingIngredient("1/4 cup TJ's Nori Komi Furikake", purchased: false),
      ],
    ),
    ShoppingListRecipe(
      Recipe(title: 'Orange Mojito Mocktail'),
      [
        ShoppingIngredient("3 large TJ's Mint Leaves", purchased: false),
        ShoppingIngredient("1/4 TJ's Lime, cut into wedges", purchased: false),
        ShoppingIngredient("3/4 cup TJ's Organic Cold Pressed Orange Juice", purchased: false),
        ShoppingIngredient("1/2 cup TJ's Sparkling Lime Water", purchased: false),
        ShoppingIngredient("Ice (optional)", purchased: false),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return MainPage(
      name: 'Shopping List',
      backgroundImage: 'https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/cranberry-orange-cornbread.jpg',
      pageSheet: PageSheet([
        SheetTab(
          name: 'By Recipe', 
          bodyContent: _buildByRecipe()
        ),
        SheetTab(
          name: 'All Ingredients', 
          bodyContent: null
        ),
      ]),
    );
  }

  Widget _buildByRecipe() {

    return ListView.builder(
      itemCount: shoppingList.length,
      padding: EdgeInsets.symmetric(vertical: 20),
      itemBuilder: (_, index) {
        return _buildRecipePartition(shoppingList[index]);
      }
    );
  }

  Widget _buildRecipePartition(ShoppingListRecipe shoppingRecipe) {

    List<_IngredientDisplay> ingredients = List<_IngredientDisplay>();
    for(ShoppingIngredient ingredient in shoppingRecipe.getIngredients()) {
      ingredients.add(_IngredientDisplay(ingredient, shoppingRecipe.recipe));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Text(
                  shoppingRecipe.recipe.title,
                  style: TextStyle(
                    color: StyleSheet.GREY,
                    fontSize: 21,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Container(height: 10),
                Container(
                  width: 100,
                  child: Divider(
                    color: StyleSheet.FADED_GREY,
                    thickness: 1.25,
                    height: 0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '${shoppingRecipe.ing.length} ITEMS',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: StyleSheet.GREY,
                        fontSize: 12
                      ),
                    ),
                    Container(width: 20),
                    Button(
                      onPressed: null,
                      child: Text(
                        'CLEAR ALL',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent.withOpacity(0.75),
                          fontSize: 12
                        ),
                      ),
                    )
                  ],
                )
                
              ]
            ),
          ),
          Column(
            children: ingredients,
          )
        ],
      ),
    );
  }
}

class _IngredientDisplay extends StatelessWidget {

  final ShoppingIngredient ingredient;
  final Recipe associatedRecipe;
  _IngredientDisplay(this.ingredient, this.associatedRecipe);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        color: ingredient.purchased ? StyleSheet.TRANSPARENT : StyleSheet.WHITE,
        constraints: BoxConstraints(minHeight: 60),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 25),
          child: Row(
            children: <Widget>[
              Checkoff(
                color: StyleSheet.GREY,
                initialValue: ingredient.purchased,
                onTap: (bool purchased) { 
                  //update controller
                }
              ),
              Expanded(
                child: Opacity(
                  opacity: ingredient.purchased ? 0.3 : 1,
                  child: Text(
                    ingredient.ingredient,
                    style: TextStyle(
                      color: StyleSheet.DARK_GREY,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      decoration: ingredient.purchased ? TextDecoration.lineThrough : TextDecoration.none
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}