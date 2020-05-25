import 'dart:ui';

import 'package:CookMate/provider/pageModel.dart';
import 'package:CookMate/util/cookMateIcons.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.55,
          alignment: Alignment.topRight,
          decoration: BoxDecoration(
            color: StyleSheet.DEEP_GREY,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40))
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Cookmate',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Hoefler',
                    fontSize: 28,
                  ),
                ),
                Container(height: 10),
                Container(width: 75, child: Divider(height: 0, color: Colors.white)),
                Container(height: 20),
                _menuButton('HOME', CookMateIcon.home_icon, 0),
                _menuButton('SEARCH', CookMateIcon.search_icon, 1),
                _menuButton('CATALOG', CookMateIcon.catalog_icon, 2),
                _menuButton('SHOPPING BAG', CookMateIcon.bag_icon, 3)
              ],
            ),
          ),
        )
      ],
    );
    
    
  }

  Widget _menuButton(String name, IconData icon, int index) {

    return Consumer<PageModel>(
      builder: (context, model, content) {
        return Button(
          onPressed: () => model.nextPage = index,
          child: AnimatedOpacity(
            opacity: model.nextPage == index ? 1 : 0.3,
            duration: Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            child: content,
          )
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(
                name,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            Container(width: 20),
            Icon(icon, color: Colors.white),
          ]
        ),
      ),
    );
  }
}