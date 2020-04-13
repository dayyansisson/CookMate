import 'package:CookMate/Entities/entity.dart';
import 'package:CookMate/Entities/ingredient.dart';

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
  String category; //should be an enum
  String prepTime;
  String cookTime;
  String servings;
  String url;
  List<String> tags = [];
  List<String> ingredients = [];
  // List<Ingredient> ingredients = [];
  List<String> steps = [];

  // Recipe Constructor
  Recipe({
    this.id,
    this.title,
    this.description,
    this.image,
    this.category,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.url,
    this.tags,
    this.ingredients,
    this.steps,
  });

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
      // 'tags': tags,
      // 'ingredients': ingredients,
      // 'steps': steps,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Returns an object
  // static Recipe fromMap(Map<String, dynamic> map) {
  //   return Recipe(
  //     id: map['id'],
  //     title: map['title'],
  //     description: map['description'],
  //     imageURL: map['imageURL'],
  //     category: map['category'],
  //     prepTime: map['prepTime'],
  //     cookTime: map['cookTime'],
  //     servings: map['servings'],
  //     tags: map['tags'],
  //     ingredients: map['ingredients'],
  //     steps: map['steps'],
  //   );
  // }
  static Recipe fromMap(Map<String, dynamic> map) {
    // List<String> allTags;
    // allTags.addAll(map['tags']);

    // List<String> allIng;
    // allIng.addAll(map['ingredients']);

    return Recipe(
      // id: map['id'],
      title: map['title'],
      description: map['description'],
      image: map['image'],
      category: map['category'],
      prepTime: map['cook_time'],
      cookTime: map['cook_time'],
      servings: map['serves'],
      url: map['url'],
      // tags: allTags,
      // ingredients: allIng,
      // steps: map['steps'],
    );
  }
}
