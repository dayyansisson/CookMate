import 'dart:async';
import 'package:CookMate/Enums/category.dart';
import 'package:CookMate/Entities/entity.dart';
import 'package:CookMate/Entities/recipe.dart';
import 'package:sqflite/sqflite.dart';

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
      print("DB was created.");
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async => await db.execute("""
      CREATE TABLE recipe (
        id INTEGER PRIMARY KEY NOT NULL,
        title STRING,
        description STRING,
        imageURL STRING,
        category STRING,
        prepTime STRING,
        cookTime STRING,
        servings STRING,
        tags STRING,
        ingredients STRING,
        steps STRING
      )
    """);

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table, Entity entity) async =>
      await _db.insert(table, entity.toMap(),
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
    print("Found category: $category");
    return _db.rawQuery('SELECT * FROM ${Recipe.table} WHERE category=?',
        [catToString(category)]);
  }

  // Returns all recipes
  static Future<List<Map<String, dynamic>>> getRecipes() {
    return _db.query(Recipe.table);
  }
}
