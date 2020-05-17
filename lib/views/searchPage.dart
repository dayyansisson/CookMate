import 'package:CookMate/entities/query.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/pageLayout/mainPage.dart';
import 'package:CookMate/widgets/pageLayout/pageSheet.dart';
import 'package:CookMate/widgets/pageLayout/sheetTab.dart';
import 'package:CookMate/widgets/searchBar.dart';
import 'package:CookMate/widgets/tag.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainPage(
      name: 'Search',
      backgroundImage: StyleSheet.DEFAULT_RECIPE_IMAGE,
      pageSheet: PageSheet([
        SheetTab(
          name: 'Ingredients', 
          searchBar: SearchBar(),
          bodyContent: Column(
            children: <Widget>[
              _QueryList(
                [
                  Query(ingredient: 'Red Chili Flakes', resultCount: 4),
                  Query(ingredient: 'Chicken', resultCount: 2),
                  Query(ingredient: 'Other', resultCount: 7)
                ]
              )
            ],
          )
        )
      ]),
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

  static const Duration tagAnimationDuration = const Duration(milliseconds: 1000);

  GlobalKey<AnimatedListState> _listKey;
  
  @override
  void initState() { 

    super.initState();
    
    _listKey = GlobalKey<AnimatedListState>();
    delayAddItems();  // TODO remove
  }

  void delayAddItems() async {

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      print('here');
      _listKey.currentState.insertItem(0, duration: tagAnimationDuration);
      _listKey.currentState.insertItem(1, duration: tagAnimationDuration);
      _listKey.currentState.insertItem(2, duration: tagAnimationDuration);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      color: Colors.white,
      alignment: Alignment.center,
      child: AnimatedList(
        key: _listKey,
        scrollDirection: Axis.horizontal,
        //itemCount: widget.queries.length,
        shrinkWrap: true,
        itemBuilder: (_, index, animation) {
          return ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Tag(
                query: widget.queries[index],
                color: Colors.redAccent,
                textColor: Colors.redAccent,
                onPressed: () {
                  setState(() {
                    Widget tag = Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Tag(
                        query: widget.queries[index],
                        color: Colors.redAccent,
                        textColor: Colors.redAccent
                      )
                    );
                    widget.queries.removeAt(index);
                    _listKey.currentState.removeItem(
                      index,
                      (context, animation) {
                        return ScaleTransition(
                          scale: CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
                          child: tag
                        );
                      },
                      duration: Duration(milliseconds: 250)
                    );
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}