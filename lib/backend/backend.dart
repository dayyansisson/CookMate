import 'dart:async';
import 'dart:convert';
import 'package:CookMate/Entities/ingredient.dart';
import 'package:CookMate/Enums/category.dart';
import 'package:CookMate/Entities/entity.dart';
import 'package:CookMate/entities/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

/*
TODOs:
  - Need to populate recipe_ingredient table
  - Need to populate ingredient table
  - Need to implement shopping cart
*/

abstract class DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'cookmate_db';
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
      "ingredient_name"	TEXT,
      "qty"	INTEGER,
      "measurement"	TEXT,
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
    // await db.execute("""

    // """);
    print("DB created.");

    addRecipesFromFile();
  }

  static Future<void> addRecipesFromFile() async {
    print("Trying to read json file of recipes and add them to db.");
    String jsonRecipes = await rootBundle.loadString('assets/recipes.json');
    Map<String, dynamic> data = json.decode(jsonRecipes);
    data.forEach((k, v) {
      var newRecipe = Recipe(
        title: v['title'],
        description: v['description'],
        image: v['image'],
        category: v['category'],
        prepTime: null,
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

          // Populate ingredient table and recipe_ingredient
          var ing = v['ingredients'];
          ing.forEach((ingKey, ingredient) {
            ingredient = ingredient.toString();
            Map<String, dynamic> newIng = {"name": ingredient, 'barcode': null};
            insertWithMap('ingredient', newIng);

            getIngredientID(ingredient).then((id) {
              Map<String, dynamic> mapIngredient = {
                "recipe_id": recipeID,
                "ingredient_id": id,
                "ingredient_name": ingredient,
                "qty": null,
                "measurement": null,
              };
              insertWithMap('recipe_ingredient', mapIngredient);
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

  static List<Recipe> getTodayRecipes() {}

  // Returns recipes by category
  static Future<List<Recipe>> getRecipesByCategory(Category category) async {
    List<Map<String, dynamic>> _results;
    _results = await queryBy(Recipe.table, "category", catToString(category));
    return _results.map((recipe) => Recipe.fromMap(recipe)).toList();
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

  // Returns all ingredients for a given recipe
  static Future<Recipe> getRecipe(String id) async {
    var _result = await queryBy('recipe', 'id', id);
    return Recipe.fromMap(_result.first);
  }

  // Returns all ingredients for a given recipe
  static Future<List<String>> getIngredientsForRecipe(String id) async {
    List<Map<String, dynamic>> _results;
    _results = await queryBy('recipe_ingredient', 'recipe_id', id);
    return _results
        .map((ingredient) => ingredient['ingredient_name'])
        .toList()
        .cast<String>();
  }

  // Returns all recipes that have given ingredients
  static Future<List<int>> getRecipeWithIngredients(List<String> ing) async {
    List<Map<String, dynamic>> _results;
    String conditions = """""";
    for (var i = 0; i < ing.length; i++) {
      conditions += """ingredient_name = "${ing.elementAt(i)}" OR """;
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

  // Returns all tags for a given recipe
  static Future<List<String>> getTagsForRecipe(String id) async {
    List<Map<String, dynamic>> _results;
    _results = await queryBy('recipe_tag', 'recipe_id', id);
    return _results.map((tag) => tag['tag_name']).toList().cast<String>();
  }

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

  // Returns all tags
  static Future<List<Map<String, dynamic>>> getTags() {
    return _db.query('tag');
  }

  // Returns all recipe_tags
  static Future<List<Map<String, dynamic>>> getRecipeTags() {
    return _db.query('recipe_tag');
  }

  // Returns tag ID by tag name
  static Future<int> getTagID(String tagName) {
    Future<List<Map<String, dynamic>>> tagMap =
        queryBy('tag', 'name', '$tagName');
    return tagMap.then((tag) => tag[0]['id']);
  }

  // Returns ingredient ID by ingredient name
  static Future<int> getIngredientID(String ingredient) {
    Future<List<Map<String, dynamic>>> ingMap =
        queryBy('ingredient', 'name', '$ingredient');
    return ingMap.then((ing) => ing[0]['id']);
  }

  static Future<List<Map<String, dynamic>>> isRecipeAFavorite(String id) {
    Future<List<Map<String, dynamic>>> recipeIsFavorite =
        _db.query('favorite', where: 'recipe_id = ?', whereArgs: [id]);
    return recipeIsFavorite;
  }
}
