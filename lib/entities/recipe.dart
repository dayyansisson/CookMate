import 'dart:collection';
import 'package:CookMate/entities/entity.dart';
// import 'package:CookMate/backend/backend.dart';
import 'package:CookMate/backend/backend2.dart';

/*
  This file lays out the recipe class. 
*/

class Recipe extends Entity {
  static String table = 'recipe';

  // Properties
  int id;
  String title;
  String description;
  String image;
  String category;
  String prepTime;
  String cookTime;
  String servings;
  String url;
  List<String> tags;
  List<String> ingredients; // List<Ingredient> ingredients;
  List<String> steps;
  bool favorite;

  // Recipe Constructor
  Recipe({
    this.id,
    this.title,
    this.description,
    this.image,
    this.category,
    this.prepTime,
    this.cookTime,
    this.url,
    this.servings,
    this.tags,
    this.ingredients,
    this.steps,
  });

  Future<void> addToFavorites() async {
    favorite = true;
    // DB.favoriteRecipe("$id");
    DB.addToFavorites(id);
  }

  Future<void> removeFromFavorites() async {
    favorite = false;
    // DB.unfavoriteRecipe("$id");
    DB.removeFromFavorites(id);
  }

  Future<bool> isFavorite() async {
    // if (favorite != null) {
    //   return favorite;
    // }
    return DB.isRecipeAFavorite(id);
  }

  Future<List<String>> getIngredients() async {
    if (ingredients != null) {
      return ingredients;
    }
    // ingredients = await DB.getIngredientsForRecipe("$id");
    // return ingredients;
  }

  Future<List<String>> getSteps() async {
    if (steps != null) {
      return steps;
    }
    // steps = await DB.getStepsForRecipe("$id");
    // return steps;
  }

  Future<List<String>> getTags() async {
    if (tags != null) {
      return tags;
    }
    // tags = await DB.getTagsForRecipe("$id");
    // return tags;
  }

  // Returns a JSON version
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'image': image,
      'category': category,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'url': url,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Returns a Recipe object from a map
  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      image: map['image'],
      category: map['category'],
      prepTime: map['prepTime'],
      cookTime: map['cookTime'],
      servings: map['servings'],
      url: map['url'],
    );
  }

  // Returns a Recipe object from a map
  static Recipe fromHive(LinkedHashMap<dynamic, dynamic> map) {
    // print("id");
    // print(map['id']);
    // print("title");
    // print(map['title']);
    List<String> tags = List<String>();
    map['tags'].forEach((_, v) => tags.add(v));
    List<String> steps = List<String>();
    map['steps'].forEach((_, v) => steps.add(v));
    List<String> ingredients = List<String>();
    map['ingredients'].forEach((_, v) => ingredients.add(v));
    return Recipe(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      image: map['image'],
      category: map['category']['0'] ?? "",
      prepTime: map['prep_time'],
      cookTime: map['cook_time'],
      servings: map['serves'],
      url: map['url'],
      tags: tags,
      steps: steps,
      ingredients: ingredients,
    );
  }
}
