import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/widgets/recipeCard.dart';
import 'package:flutter/material.dart';

class RecipeCardList extends StatelessWidget {

  final Future<List<Recipe>> recipes;
  RecipeCardList(this.recipes);

  @override
  Widget build(BuildContext context) {

    if(recipes == null) {
      return Container();
    }

    return FutureBuilder<List<Recipe>>(
      future: recipes,
      builder: (_, snapshot) {
        if(snapshot.hasData) {
          return listDisplay(snapshot.data);
        } else if(snapshot.data == null) {
          return Container();
        }
        return Center(
          child: CircularProgressIndicator()
        );
      },
    );
  }

  Widget listDisplay(List<Recipe> recipeList) {

    return ListView.builder(
      itemCount: recipeList.length,
      padding: EdgeInsets.only(top: 20),
      itemBuilder: (_, index) {
        return RecipeCard(recipeList[index]);
      }
    );
  }
}