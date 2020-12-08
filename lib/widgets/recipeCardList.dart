import 'package:CookMate/entities/recipe.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/recipeCard.dart';
import 'package:flutter/material.dart';

class RecipeCardList extends StatelessWidget {
  final Future<List<Recipe>> recipes;
  final String emptyMessage;
  RecipeCardList(this.recipes, {this.emptyMessage = ""});

  @override
  Widget build(BuildContext context) {
    if (recipes == null) {
      return Container();
    }

    return FutureBuilder<List<Recipe>>(
      future: recipes,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width * (2 / 3),
                child: Text(
                  emptyMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: StyleSheet.GREY, fontSize: 18, height: 1.2),
                ),
              ),
            );
          }
          return listDisplay(snapshot.data);
        } else if (snapshot.data == null) {
          return Container();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget listDisplay(List<Recipe> recipeList) {
    return ListView.builder(
        itemCount: recipeList.length,
        padding: EdgeInsets.only(top: 20),
        itemBuilder: (_, index) {
          return RecipeCard(recipeList[index]);
        });
  }
}
