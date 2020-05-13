import 'package:CookMate/provider/pageModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/views/catalogPage.dart';
import 'package:CookMate/views/homePage.dart';
import 'package:CookMate/views/searchPage.dart';
import 'package:CookMate/views/shoppingListPage.dart';
import 'package:CookMate/widgets/navBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Driver extends StatelessWidget {

  final PageController _controller;
  Driver() : _controller = PageController();

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider<PageModel>(
      create: (_) => PageModel(),
      child: Scaffold(
        body:  Consumer<PageModel>(
          builder: (context, model, _) {
            changePage(model);
            return PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              children: <Widget>[
                HomePage(),
                SearchPage(),
                CatalogPage(),
                // ShoppingListPage(),
              ]
            );
          }
        ),
        backgroundColor: StyleSheet.WHITE,
        bottomNavigationBar: NavBar(),
      ),
    );
  }
  
  void changePage(PageModel model) {

    if(_controller.hasClients) {
      _controller.animateToPage(
        model.nextPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut
      );
    }
  }
}
