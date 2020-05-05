import 'dart:io';
import 'dart:ui';
import 'package:CookMate/provider/pageModel.dart';
import 'package:CookMate/provider/searchModel.dart';
import 'package:CookMate/Controllers/SearchController.dart';
import 'package:CookMate/Entities/recipe.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/dropdown%20menu/dropdownSearch.dart';
import 'package:CookMate/widgets/navBar.dart';
import 'package:CookMate/widgets/page%20layout/mainPage.dart';
import 'package:CookMate/widgets/page%20layout/pageSheet.dart';
import 'package:CookMate/widgets/page%20layout/sheetTab.dart';
import 'package:CookMate/widgets/recipeCard.dart';
import 'package:CookMate/widgets/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:CookMate/util/cookMateIcons.dart';
import 'package:provider/provider.dart';
import 'package:CookMate/Controllers/HomeController.dart';

//import 'Controllers/CatalogController.dart';

/* This class only exists for us to develop different parts of the app 
   without affecting each other's work.
*/

class Playground extends StatelessWidget {

PageController _controller;
Playground() {_controller = PageController();}

  @override
Widget build(BuildContext context) {
  
    return ChangeNotifierProvider<SearchModel>(
      create: (_) => SearchModel(),
      child: Scaffold(
        body:  Consumer<SearchModel>(
          builder: (context, model, _) {
            //changePage(model);
            return PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              children: <Widget>[
                Page2(),
                Page4(),
                Page4(),
                Page5()
              ]
            );
          }
        ),
        backgroundColor: Colors.red,
        //bottomNavigationBar: NavBar(),
      ),
    );
}
  


  changePage(PageModel model) {
    if (model.onHome == false && model.nextPage == 0) {
      _controller.jumpToPage(model.nextPage);
    }
    if (model.onSearch == false && model.nextPage == 1) {
      _controller.jumpToPage(model.nextPage);
    }
    if (model.onCatalog == false && model.nextPage == 2) {
      _controller.jumpToPage(model.nextPage);
    }
    if (model.onSearch == false && model.nextPage == 3) {
      _controller.jumpToPage(model.nextPage);
    }
  }
}

class Page2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        child: Column(
          children: <Widget>[
            SearchBar(),
            DropDownSearch()
          ],
        ),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Page 4'),
      ),
    );
  }
}
class Page5 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Page 5'),
      ),
    );
  }
}
