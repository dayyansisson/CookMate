import 'dart:async';
import 'dart:convert';
import 'package:CookMate/Entities/ingredient.dart';
import 'package:CookMate/Enums/category.dart';
import 'package:CookMate/Entities/entity.dart';
import 'package:CookMate/Entities/recipe.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/services.dart' show rootBundle;

/*
TODOs:
  - Need to populate recipe_ingredient table
  - Need to populate ingredient table
  - Need to handle favorites recipes
  - Need to handle featured recipes
  - Need to implement shopping cart
  - 

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
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "title"	TEXT NOT NULL UNIQUE,
      "image"	TEXT,
      "category"	TEXT,
      "description"	TEXT,
      "url"	TEXT,
      "cookTime"	TEXT,
      "prepTime"	TEXT,
      "servings"	INTEGER
    )
    """);

    // TODO: need to add from json
    await db.execute("""
    CREATE TABLE "ingredient" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "name"	TEXT NOT NULL UNIQUE,
      "barcode"	TEXT UNIQUE
    )
    """);

    await db.execute("""
    CREATE TABLE "tag" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "name"	TEXT NOT NULL UNIQUE
    )
    """);

    // TODO: need to add from json
    await db.execute("""
    CREATE TABLE "recipe_ingredient" (
      "id"	INTEGER PRIMARY KEY AUTOINCREMENT,
      "recipe_id"	INTEGER NOT NULL,
      "ingredient_id"	INTEGER NOT NULL,
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
      Recipe newRecipe = Recipe.fromMap(v);
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

  static List<Recipe> getAppetizerRecipes() {}

  static List<Recipe> getBeverageRecipes() {}

  static List<Recipe> getBreakfastRecipes() {}

  static List<Recipe> getLunchRecipes() {}

  static List<Recipe> getDinnerRecipes() {}

  static List<Recipe> getFeaturedRecipes() {}

  static List<Recipe> getFavoriteRecipes() {}

  static List<Recipe> getTodayRecipes() {}

  // Returns recipes by category
  static Future<List<Map<String, dynamic>>> getRecipesByCategory(
      Category category) {
    // TODO: return a list not a future? I think gabe wanted this:
    // _results.map((recipe) => Recipe.fromMap(recipe)).toList();
    print("Looking for recipes by category: $category");
    return queryBy(Recipe.table, "category", catToString(category));
  }

  // Returns all recipes
  static Future<List<Map<String, dynamic>>> getRecipes() {
    return _db.query(Recipe.table);
  }

  // Returns all ingredients
  static Future<List<Map<String, dynamic>>> getIngredients() {
    return _db.query(Ingredient.table);
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
}
