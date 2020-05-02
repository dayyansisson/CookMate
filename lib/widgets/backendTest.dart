import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/Enums/category.dart';
import 'package:CookMate/backend/backend.dart';
import 'package:flutter/material.dart';

class BackendTest extends StatefulWidget {
  @override
  _BackendTestState createState() => _BackendTestState();
}

class _BackendTestState extends State<BackendTest> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                var recipes = DB.getRecipesByCategory(Category.beverages);
                recipes.then((allRecipes) {
                  allRecipes.forEach((recipe) {
                    print("${recipe.title}: ${recipe.category}");
                  });
                });
              },
              child: Text(
                "beverages",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                var recipes = DB.getRecipesByCategory(Category.lunch);
                recipes.then((allRecipes) {
                  allRecipes.forEach((recipe) {
                    print("${recipe.title}: ${recipe.category}");
                  });
                });
              },
              child: Text(
                "Lunch",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                print("Need to get featured or today");
              },
              child: Text(
                "Featured",
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                List<Map<String, dynamic>> _results = await DB.getRecipes();
                var _recipes =
                    _results.map((recipe) => Recipe.fromMap(recipe)).toList();
                for (var rec in _recipes) {
                  print(rec.title);
                }
              },
              child: Text(
                "All Recipes",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Recipe fakeRec = new Recipe(
                  category: 'breakfast',
                  cookTime: '10min',
                  description: "long description of this cool recipe",
                  title: 'cereal',
                );
                Recipe fakeRec2 = new Recipe(
                  category: 'desserts',
                  cookTime: '10min',
                  description: "long description of this cool recipe",
                  title: 'dessertmeal',
                );
                Recipe fakeRec3 = new Recipe(
                  category: 'lunch',
                  cookTime: '10min',
                  description: "long description of this cool recipe",
                  title: 'lunchmeal',
                );
                Recipe fakeRec4 = new Recipe(
                  category: 'dinner',
                  cookTime: '10min',
                  description: "long description of this cool recipe",
                  title: 'dinnermeal',
                );
                DB.insert(Recipe.table, fakeRec);
                DB.insert(Recipe.table, fakeRec2);
                DB.insert(Recipe.table, fakeRec3);
                DB.insert(Recipe.table, fakeRec4);
              },
              child: Text(
                "Test Inserting",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                DB.addRecipesFromFile();
              },
              child: Text(
                "None",
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                List<Map<String, dynamic>> _results = await DB.getTags();
                _results.forEach((tag) {
                  print("${tag['id']} : ${tag['name']}");
                });
              },
              child: Text(
                "Get All Tags",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                var test = await DB.getTagID('Corn');
                print("Corn has an id of: $test");
              },
              child: Text(
                "Get TagID for Corn",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                List<Map<String, dynamic>> _results = await DB.getRecipeTags();
                _results.forEach((tag) async {
                  var recipe_name = await DB.queryBy(
                      'recipe', 'id', tag['recipe_id'].toString());
                  var recipe_title = recipe_name[0]['title'];
                  var tag_name =
                      await DB.queryBy('tag', 'id', tag['tag_id'].toString());
                  print(
                      "${tag['id']} : RecipeID:${tag['recipe_id']} RecTitle: $recipe_name TagID:${tag['tag_id']} TagName: $tag_name");
                });
              },
              child: Text(
                "Show recipe_tag",
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                List<Map<String, dynamic>> _results = await DB.getRecipes();
                var _recipes =
                    _results.map((recipe) => Recipe.fromMap(recipe)).toList();
                _recipes.forEach((rec) {
                  // print("${rec.id}: ${rec.title}");
                  if (rec.id == 213) {
                    print("Recipe:\n${rec.id}: ${rec.title}");

                    var ings = rec.getIngredients();
                    ings.then((onValue) {
                      print("Ingredients:");
                      print(onValue);
                    });

                    var steps = rec.getSteps();
                    steps.then((onValue) {
                      print("Steps:");
                      print(onValue);
                    });

                    var tags = rec.getTags();
                    tags.then((onValue) {
                      print("Tags:");
                      print(onValue);
                    });
                  }
                });
              },
              child: Text(
                "Recipe with id 213",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                var rec = await DB.getRecipe("213");
                print("${rec.id}: ${rec.title}");
                if (rec.id == 213) {
                  print(
                      "Recipe:\n${rec.id}: ${rec.title} servs:${rec.servings} cookTime:${rec.cookTime}");

                  var ings = rec.getIngredients();
                  ings.then((onValue) {
                    print("Ingredients:");
                    print(onValue);
                  });

                  var steps = rec.getSteps();
                  steps.then((onValue) {
                    print("Steps:");
                    print(onValue);
                  });

                  var tags = rec.getTags();
                  tags.then((onValue) {
                    print("Tags:");
                    print(onValue);
                  });
                }
              },
              child: Text(
                "Only Recipe 213",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                DB.favoriteRecipe("213");
                DB.favoriteRecipe("214");
                DB.favoriteRecipe("2");
                DB.unfavoriteRecipe("214");
                var _results = await DB.getFavoriteRecipes();
                _results.forEach((fav) {
                  print(fav);
                });
              },
              child: Text(
                "All Favorites",
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                var _results = await DB.getFeaturedRecipes();
                // print(_results);
                // print("Searched for: ${ingredients.elementAt(2)}");
                _results.forEach((recipe) {
                  print("${recipe.category}, ${recipe.title}");
                });
              },
              child: Text(
                "Featured",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                List<String> ingredients = [
                  "Buns",
                  "Fresh",
                  "man",
                  "Sea",
                  "Quin",
                  "ed Onion",
                ];
                var _results =
                    await DB.findIngredients(ingredients.elementAt(2));
                // print(_results);
                print("Searched for: ${ingredients.elementAt(2)}");
                _results.forEach((ing) {
                  print(ing);
                });
              },
              child: Text(
                "Find ing",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                List<String> ingredients = [
                  "4 TJ's Whole Wheat Hamburger Buns",
                  "TJ's Fresh Cilantro, chopped",
                  "TJ's Amba Mango Sauce",
                  "TJ's Sea Salt",
                  "1 package TJ's Quinoa Cowboy Veggie Burgers",
                  "1/2 TJ's Red Onion, diced"
                ];
                // recipe 22, 23
                var _results = await DB.getRecipeWithIngredients(ingredients);
                _results.forEach((recipe) {
                  print(recipe);
                });
              },
              child: Text(
                "Recipes with ing.",
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                List<String> recipes = [
                  "Buns",
                  "Fresh",
                  "man",
                  "Sea",
                  "Quin",
                  "ed Onion",
                ];
                var _results = await DB.findRecipe(recipes.elementAt(2));
                // print(_results);
                print("Searched for: ${recipes.elementAt(2)}");
                _results.forEach((rec) {
                  print(rec);
                });
              },
              child: Text(
                "Find recipe substring",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                DB.favoriteRecipe("177");
                DB.favoriteRecipe("214");
                DB.favoriteRecipe("2");
                DB.unfavoriteRecipe("214");

                var _fav = await DB.isRecipeAFavorite("177");
                if (_fav.length > 0) {
                  print("Found recipe 177");
                } else {
                  print("Recipe 177 is not a fav");
                }
                var _fav2 = await DB.isRecipeAFavorite("214");
                if (_fav2.length > 0) {
                  print("Found recipe 214");
                } else {
                  print("Recipe 214 is not a fav");
                }
                var rec = await DB.getRecipe("214");
                print("Is 214 a fav: ${await rec.isFavorite()}");

                var rec2 = await DB.getRecipe("177");
                print("Is 177 a fav: ${await rec2.isFavorite()}");
              },
              child: Text(
                "Check Favorites",
              ),
            ),
          ],
        )
      ],
    );
  }
}
