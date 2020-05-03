import 'package:CookMate/provider/pageModel.dart';
import 'package:CookMate/util/styleSheet.dart';
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
                TestPage(1),
                TestPage(2),
                TestPage(3),
                TestPage(4),
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
      _controller.jumpToPage(model.nextPage);
    }
  }
}


class TestPage extends StatelessWidget {

  final int index;
  TestPage(this.index);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(index.toString()),
      ),
    );
  }
}
