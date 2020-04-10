import 'package:CookMate/Entities/entity.dart';
import 'package:CookMate/Entities/ingredient.dart';
import 'package:CookMate/Entities/tag.dart';

/*
  This file lays out the recipe class. 
*/

class Recipe extends Entity {
  static String table = 'recipe';

  // Properties
  int id;
  String title;
  String description;
  String imageURL;
  String category; //should be an enum
  String prepTime;
  String cookTime;
  String servings;
  List<Tag> tags = [];
  List<Ingredient> ingredients = [];
  List<String> steps = [];

  // Recipe Constructor
  Recipe({
    this.id,
    this.title,
    this.description,
    this.imageURL,
    this.category,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.tags,
    this.ingredients,
    this.steps,
  });

  // Returns a JSON version
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'imageURL': imageURL,
      'category': category,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'tags': tags,
      'ingredients': ingredients,
      'steps': steps,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Returns an object
  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imageURL: map['imageURL'],
      category: map['category'],
      prepTime: map['prepTime'],
      cookTime: map['cookTime'],
      servings: map['servings'],
      tags: map['tags'],
      ingredients: map['ingredients'],
      steps: map['steps'],
    );
  }
}
