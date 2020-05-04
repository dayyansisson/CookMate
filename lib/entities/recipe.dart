import 'package:CookMate/entities/entity.dart';
import 'package:CookMate/backend/backend.dart';

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
  String prepTime; //prepTime is not in data yet
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
    this.steps
  });

  Future<void> addToFavorites() async {
    favorite = true;
    DB.favoriteRecipe("$id");
  }

  Future<void> removeFromFavorites() async {
    favorite = false;
    DB.unfavoriteRecipe("$id");
  }

  Future<bool> isFavorite() async {
    if (favorite != null) {
      return favorite;
    }
    var _result = await DB.isRecipeAFavorite("$id");
    favorite = _result.length > 0;
    return favorite;
  }

  Future<List<String>> getIngredients() async {
    if (ingredients != null) {
      return ingredients;
    }
    ingredients = await DB.getIngredientsForRecipe("$id");
    return ingredients;
  }

  Future<List<String>> getSteps() async {
    if (steps != null) {
      return steps;
    }
    steps = await DB.getStepsForRecipe("$id");
    return steps;
  }

  Future<List<String>> getTags() async {
    if (tags != null) {
      return tags;
    }
    tags = await DB.getTagsForRecipe("$id");
    return tags;
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
      prepTime: null,
      cookTime: map['cookTime'],
      servings: map['servings'],
      url: map['url'],
    );
  }
}
