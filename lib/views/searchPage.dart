import 'package:CookMate/controllers/searchController.dart';
import 'package:CookMate/entities/query.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/pageLayout/mainPage.dart';
import 'package:CookMate/widgets/pageLayout/pageSheet.dart';
import 'package:CookMate/widgets/pageLayout/sheetTab.dart';
import 'package:CookMate/widgets/recipeCardList.dart';
import 'package:CookMate/widgets/searchBar.dart';
import 'package:CookMate/widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MainPage(
      name: 'Search',
      backgroundImage: 'https://www.traderjoes.com/TJ_CMS_Content/Images/Recipe/poached-egg-latkes.jpg',
      pageSheet: PageSheet([
        SheetTab(
          name: 'Recipes', 
          searchBar: SearchBar(SearchType.Recipe),
          bodyContent: _buildRecipePage()
        ),
        SheetTab(
          name: 'Ingredients', 
          searchBar: SearchBar(SearchType.Ingredient),
          bodyContent: _buildIngredientPage()
        )
      ]),
    );
  }

  Widget _buildRecipePage() {

    return ChangeNotifierProvider<SearchController>.value(
      value: SearchController(),
      child: Consumer<SearchController> (
        builder: (context, controller, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: RecipeCardList(SearchController().recipeSearchResults),
          );
        },
      ),
    );
  }

  Widget _buildIngredientPage() {

    return ChangeNotifierProvider<SearchController>.value(
      value: SearchController(),
      child: Consumer<SearchController> (
        builder: (context, controller, _) {
          List<String> ingredients = controller.currentIngredients;
          List<Query> queries = List<Query>();
          for(String ingredient in ingredients) {
            queries.add(Query(ingredient: ingredient, resultCount: 0));
          }
          return Column(
            children: <Widget>[
              _QueryList(queries),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: RecipeCardList(SearchController().ingredientSearchResults),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _QueryList extends StatefulWidget {

  final List<Query> queries;
  _QueryList(this.queries);

  @override
  __QueryListState createState() => __QueryListState();
}

class __QueryListState extends State<_QueryList> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      color: Colors.white,
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.queries.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Tag(
              query: widget.queries[index],
              color: Colors.redAccent,
              textColor: Colors.redAccent,
              onPressed: () {
                setState(() {
                  SearchController().removeIngredientFromSearch(widget.queries[index].ingredient);
                  widget.queries.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}