import 'package:CookMate/Entities/recipe.dart';
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
              onPressed: () async {
                List<Map<String, dynamic>> _results =
                    await DB.getRecipesByCategory(Category.breakfast);
                var _recipes =
                    _results.map((recipe) => Recipe.fromMap(recipe)).toList();
                for (var rec in _recipes) {
                  print(rec.title);
                }
              },
              child: Text(
                "Breakfast",
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                List<Map<String, dynamic>> _results =
                    await DB.getRecipesByCategory(Category.lunch);
                var _recipes =
                    _results.map((recipe) => Recipe.fromMap(recipe)).toList();
                for (var rec in _recipes) {
                  print(rec.title);
                }
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
                print("Test here");
              },
              child: Text(
                "None",
              ),
            )
          ],
        ),
      ],
    );
  }
}
