import 'package:CookMate/provider/pageModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/views/catalogPage.dart';
import 'package:CookMate/views/homePage.dart';
import 'package:CookMate/views/searchPage.dart';
import 'package:CookMate/views/shoppingListPage.dart';
import 'package:CookMate/widgets/menuDrawer.dart';
import 'package:CookMate/widgets/navBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Driver extends StatefulWidget {
  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageModel>(
      create: (_) => PageModel(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<PageModel>(builder: (context, model, _) {
          changePage(model);
          return PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              children: <Widget>[
                HomePage(),
                SearchPage(),
                CatalogPage(),
                ShoppingListPage(),
              ]);
        }),
        backgroundColor: StyleSheet.WHITE,
        drawer: DrawerMenu(),
        endDrawer: DrawerMenu(endDrawer: true),
      ),
    );
  }

  void changePage(PageModel model) {
    if (_controller.hasClients) {
      // _controller.animateToPage(
      //   model.nextPage,
      //   duration: Duration(milliseconds: 500),
      //   curve: Curves.easeInOut
      // );
      _controller.animateToPage(model.nextPage,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }
}
