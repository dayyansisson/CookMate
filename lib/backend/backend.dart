import 'dart:async';
import 'dart:convert';
import 'package:CookMate/entities/ingredient.dart';
import 'package:CookMate/entities/shoppingIngredient.dart';
import 'package:CookMate/enums/category.dart';
import 'package:CookMate/entities/entity.dart';
import 'package:CookMate/entities/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

/*
TODOs:
  - Need to add multiple categories
  - Figure out a way to batch insert or better yet clone an existing db to user's phone
*/

abstract class DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + '/cookmate_db';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    print("DB is being created.");

    await db.execute("""
    CREATE TABLE "recipe" (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "title" TEXT NOT NULL UNIQUE,
      "description" TEXT,
      "image" TEXT,
      "category" TEXT,
      "prepTime" TEXT,
      "cookTime" TEXT,
      "servings" TEXT,
      "url" TEXT
    )
    """);

    await db.execute("""
    CREATE TABLE "ingredient" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "name"	TEXT NOT NULL UNIQUE,
      "barcode"	TEXT
    )
    """);

    await db.execute("""
    CREATE TABLE "tag" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "name"	TEXT NOT NULL UNIQUE
    )
    """);

    await db.execute("""
    CREATE TABLE "recipe_ingredient" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "recipe_id"	INTEGER NOT NULL,
      "ingredient_id"	INTEGER NOT NULL,
      "ingredient_details"	TEXT,
      "corrected_name"	TEXT,
      FOREIGN KEY("recipe_id") REFERENCES "recipe"("id") ON DELETE CASCADE,
      FOREIGN KEY("ingredient_id") REFERENCES "ingredient"("id") ON DELETE CASCADE
    )
    """);

    await db.execute("""
    CREATE TABLE "recipe_tag" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "recipe_id"	INTEGER NOT NULL,
      "tag_id"	INTEGER NOT NULL,
      "tag_name"	TEXT,
      FOREIGN KEY("recipe_id") REFERENCES "recipe"("id") ON DELETE CASCADE,
      FOREIGN KEY("tag_id") REFERENCES "tag"("id") ON DELETE CASCADE
    )
    """);

    await db.execute("""
    CREATE TABLE "recipe_step" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "recipe_id"	INTEGER NOT NULL,
      "step"	TEXT NOT NULL,
      "order"	INTEGER NOT NULL,
      FOREIGN KEY("recipe_id") REFERENCES "recipe"("id") ON DELETE CASCADE
    )
    """);

    await db.execute("""
    CREATE TABLE "favorite" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "recipe_id"	INTEGER NOT NULL UNIQUE,
      FOREIGN KEY("recipe_id") REFERENCES "recipe"("id") ON DELETE CASCADE
    )
    """);

    await db.execute("""
    CREATE TABLE "featured" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "recipe_id"	INTEGER NOT NULL UNIQUE,
      FOREIGN KEY("recipe_id") REFERENCES "recipe"("id") ON DELETE CASCADE
    )
    """);

    // Shopping Cart
    await db.execute("""
    CREATE TABLE "cart" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "recipe_id"	INTEGER NOT NULL,
      "item"	TEXT NOT NULL,
      "purchased"	INTEGER DEFAULT 0,
      FOREIGN KEY("recipe_id") REFERENCES "recipe"("id") ON DELETE CASCADE
    )
    """);

    print("DB created.");

    addRecipesFromFile();
  }

  static Future<void> addRecipesFromFile() async {
    print("Trying to read json file of recipes and add them to db.");
    String jsonRecipes = await rootBundle.loadString('assets/new_recipes.json');
    Map<String, dynamic> data = json.decode(jsonRecipes);
    data.forEach((k, v) {
      var newRecipe = Recipe(
        title: v['title'],
        description: v['description'],
        image: v['image'],
        category: v['category']['0'], // TODO: need to add all categories
        prepTime: v['prep_time'],
        cookTime: v['cook_time'],
        servings: v['serves'],
        url: v['url'],
      );
      Future<int> success = insert(Recipe.table, newRecipe);
      success.then((recipeID) {
        if (recipeID != null) {
          // Adding the steps per recipe:
          var steps = v['steps'];
          steps.forEach((stepKey, step) {
            Map<String, dynamic> mapStep = {
              "recipe_id": recipeID,
              "step": step.toString(),
              "order": stepKey.toString()
            };
            insertWithMap('recipe_step', mapStep);
          });

          // Populate ingredient table
          List<String> detailedIng = new List();
          var detailedIngredients = v['ingredients'];
          detailedIngredients.forEach((ingKey, ingredient) {
            detailedIng.add(ingredient.toString());
          });

          // Ingredient details
          var ing = v['corrected_ing'];
          int count = 0;
          ing.forEach((ingKey, ingredient) {
            ingredient = ingredient.toString();
            Map<String, dynamic> newIng = {"name": ingredient, 'barcode': null};
            insertWithMap('ingredient', newIng);

            getIngredientID(ingredient).then((id) {
              Map<String, dynamic> mapIngredient = {
                "recipe_id": recipeID,
                "ingredient_id": id,
                "ingredient_details": detailedIng.elementAt(count),
                "corrected_name": ingredient,
              };
              insertWithMap('recipe_ingredient', mapIngredient);
              count += 1;
            });
          });

          // Adding the tags per recipe:
          var tags = v['tags'];
          tags.forEach((tagKey, tag) {
            // print(tag.toString());
            tag = tag.toString();
            Map<String, dynamic> newTag = {"name": tag};
            insertWithMap('tag', newTag);

            getTagID(tag).then((id) {
              Map<String, dynamic> mapTag = {
                "recipe_id": recipeID,
                "tag_id": id,
                "tag_name": tag
              };
              insertWithMap('recipe_tag', mapTag);
            });
          });
        } else {
          print(
              "Inserting recipe ${v['title']} failed due to duplicate. Most likely same with different category.");
        }
      });
    });
    print("Done adding recipes to db.");
  }

  /*
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    DATABASE CALLS
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<List<Map<String, dynamic>>> queryBy(
          String table, String whereField, String whereValue) async =>
      _db.query(table, where: '$whereField = ?', whereArgs: [whereValue]);

  static Future<int> insert(String table, Entity entity) async =>
      await _db.insert(table, entity.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);

  static Future<int> insertWithMap(
          String table, Map<String, dynamic> dataMap) async =>
      await _db.insert(table, dataMap,
          conflictAlgorithm: ConflictAlgorithm.ignore);

  static Future<int> update(String table, Entity entity) async => await _db
      .update(table, entity.toMap(), where: 'id = ?', whereArgs: [entity.id]);

  static Future<int> delete(String table, Entity entity) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [entity.id]);

  /*
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    FEATURED
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */

  // TODO: will need to change when add multiple categories
  // Currently returns the first recipe of each category
  static Future<List<Recipe>> getFeaturedRecipes() async {
    List<Recipe> recipes = List<Recipe>();
    for (var cat in Category.values) {
      if (cat != Category.none) {
        List<Map<String, dynamic>> _firstCategoryRecipe = await _db.rawQuery("""
          SELECT *
          FROM recipe
          WHERE category = "${catToString(cat)}"
          LIMIT 1
        """);
        recipes.add(Recipe.fromMap(_firstCategoryRecipe.first));
      }
    }
    return recipes;
  }

  /*
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    FAVORITES
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */

  static Future<List<Map<String, dynamic>>> getFavoriteRecipes() async {
    return _db.query('favorite');
  }

  static void favoriteRecipe(String id) {
    Map<String, dynamic> mapFav = {"recipe_id": id};
    insertWithMap('favorite', mapFav);
  }

  static void unfavoriteRecipe(String id) {
    _db.delete('favorite', where: 'recipe_id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> isRecipeAFavorite(String id) {
    Future<List<Map<String, dynamic>>> recipeIsFavorite =
        _db.query('favorite', where: 'recipe_id = ?', whereArgs: [id]);
    return recipeIsFavorite;
  }

  /*
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    TODAY
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */

  static List<Recipe> getTodayRecipes() {}

  /*
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CATEGORY
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */
  // TODO: will need to change when add multiple categories
  // Returns recipes by category
  static Future<List<Recipe>> getRecipesByCategory(Category category) async {
    List<Map<String, dynamic>> _results;
    _results = await queryBy(Recipe.table, "category", catToString(category));
    return _results.map((recipe) => Recipe.fromMap(recipe)).toList();
  }

  /*
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    INGREDIENT
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */
  // Returns all ingredients
  static Future<List<Map<String, dynamic>>> getIngredients() {
    return _db.query(Ingredient.table);
  }

  // Find ingredient
  static Future<List<String>> findIngredients(String ingredient) async {
    List<Map<String, dynamic>> _results;
    _results = await _db.rawQuery("""
      SELECT *
      FROM ingredient
      WHERE name LIKE '%$ingredient%'
    """);
    return _results.map((ing) => ing['name']).toList().cast<String>();
  }

  // Returns ingredient ID by ingredient name
  static Future<int> getIngredientID(String ingredient) {
    Future<List<Map<String, dynamic>>> ingMap =
        queryBy('ingredient', 'name', '$ingredient');
    return ingMap.then((ing) => ing[0]['id']);
  }

  // Returns all recipes that have given ingredients
  static Future<List<int>> getRecipeWithIngredients(List<String> ing) async {
    List<Map<String, dynamic>> _results;
    String conditions = """""";
    for (var i = 0; i < ing.length; i++) {
      conditions += """ "corrected_name" = "${ing.elementAt(i)}" OR """;
    }
    conditions =
        conditions.substring(0, conditions.length - 4); //get rid of last OR

    _results = await _db.rawQuery("""
      SELECT *
      FROM recipe_ingredient
      WHERE $conditions
    """);
    // print("Query Conditions: $conditions");
    // print(_results);
    return _results.map((recipe) => recipe['recipe_id']).toList().cast<int>();
  }

  // Returns all ingredients for a given recipe
  static Future<List<String>> getIngredientsForRecipe(String id) async {
    List<Map<String, dynamic>> _results;
    _results = await queryBy('recipe_ingredient', 'recipe_id', id);
    return _results
        .map((ingredient) => ingredient['ingredient_details'])
        .toList()
        .cast<String>();
  }

  /*
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RECIPE
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */
  // Returns a recipe with given id
  static Future<Recipe> getRecipe(String id) async {
    var _result = await queryBy('recipe', 'id', id);
    return Recipe.fromMap(_result.first);
  }

  // Returns all recipes
  static Future<List<Map<String, dynamic>>> getRecipes() {
    return _db.query(Recipe.table);
  }

  // Find recipe by substring
  static Future<List<int>> findRecipe(String recipe) async {
    List<Map<String, dynamic>> _results;
    _results = await _db.rawQuery("""
      SELECT *
      FROM recipe
      WHERE title LIKE '%$recipe%'
    """);
    return _results.map((rec) => rec['id']).toList().cast<int>();
  }

  /*
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    TAG
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */
  // Returns all tags
  static Future<List<Map<String, dynamic>>> getTags() {
    return _db.query('tag');
  }

  // Returns all recipe_tags
  static Future<List<Map<String, dynamic>>> getRecipeTags() {
    return _db.query('recipe_tag');
  }

  // Returns all tags for a given recipe
  static Future<List<String>> getTagsForRecipe(String id) async {
    List<Map<String, dynamic>> _results;
    _results = await queryBy('recipe_tag', 'recipe_id', id);
    return _results.map((tag) => tag['tag_name']).toList().cast<String>();
  }

  // Returns tag ID by tag name
  static Future<int> getTagID(String tagName) {
    Future<List<Map<String, dynamic>>> tagMap =
        queryBy('tag', 'name', '$tagName');
    return tagMap.then((tag) => tag[0]['id']);
  }

  /*
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    STEP
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */
  // Returns all steps for a given recipe id in order
  static Future<List<String>> getStepsForRecipe(String id) async {
    List<Map<String, dynamic>> _results;
    _results = await _db.rawQuery("""
    SELECT *
    FROM recipe_step
    WHERE recipe_id = $id
    ORDER BY 'recipe_step.order'
    """);
    return _results.map((step) => step['step']).toList().cast<String>();
  }

  /*
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CART
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  CREATE TABLE "cart" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "recipe_id"	INTEGER NOT NULL,
      "item"	TEXT NOT NULL,
      "purchased"	INTEGER DEFAULT 0,
      FOREIGN KEY("recipe_id") REFERENCES "recipe"("id") ON DELETE CASCADE
    )
 */
  // Takes in recipeID and the ShoppingIngredient items and inserts
  static void addRecipeToShoppingList(
      int recipeID, List<ShoppingIngredient> ingr) {
    for (var item in ingr) {
      insertWithMap('cart', item.toMap());
    }
  }

  // Return a List of ShoppingIngredients for a given recipe id
  static Future<List<ShoppingIngredient>> getShoppingListByRecipe(int recipeID) async {
    List<Map<String, dynamic>> _results = await _db.query('cart', where: 'recipe_id = ?', whereArgs: [recipeID]);
    return _results.map((items) => ShoppingIngredient.fromMap(items)).toList();
  }

  //Returns a map of all shopping list items
  static Future<List<Map<String, dynamic>>> getShoppingList() {
    return _db.query('cart');
  }

  //Removes all items matching the recipeID
  static void removeRecipeFromShoppingList(int recipeID) {
    _db.delete('cart', where: 'recipe_id = ?', whereArgs: [recipeID]);
  }

  // trunctuates table
  static void clearAllFromShoppingList() {
    _db.delete('cart');
  }

  // An update method that pulls new info from ShoppingIngredient entity
  static Future<void> updateShoppingListItem(
      int recipeID, ShoppingIngredient ingr) async {
    await _db.update('cart', ingr.toMap(),
        where: 'recipe_id = ? AND item = ?',
        whereArgs: [ingr.recipeID, ingr.ingredient]);
  }
}
