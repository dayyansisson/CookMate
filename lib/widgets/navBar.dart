import 'dart:math';
import 'package:CookMate/provider/pageModel.dart';
import 'package:CookMate/main.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:CookMate/util/cookMateIcons.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  
  var _alignmentHome = Alignment.center;
  var _alignmentSearch = Alignment.center;
  var _alignmentCatalog = Alignment.center;
  var _alignmentBag = Alignment.center;
  var _opacityHome = 0.75;
  var _opacitySearch = .75;
  var _opacityCatalog = .75;
  var _opacityBag = .75;


  @override
  Widget build(BuildContext context) {
    return Consumer<PageModel>(
      builder: (context, model, _) {
      return Container(
        height: 50,
        color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedOpacity (
                opacity: _opacityHome,
                duration: Duration(milliseconds: 200),
                child: AnimatedContainer (
                  alignment: _alignmentHome,
                  duration: Duration(milliseconds: 200),
                  child: Button (
                    onPressed:(){ 
                      if (model.onHome == false) {
                        setState(() {              
                          _alignmentHome = Alignment(0.0, -.4);
                          _alignmentSearch = Alignment.center;
                          _alignmentCatalog = Alignment.center;
                          _alignmentBag = Alignment.center;
                          _opacityBag = .75;
                          _opacityCatalog = .75;
                          _opacitySearch = .75;
                          _opacityHome = 1.0;
                          changePage(0, model);
                        });
                      }
                    },
                    child:
                      Icon(
                        CookMateIcon.home_icon,
                        color: StyleSheet.LIGHT_GREY,
                        size: 21,
                      ),
                  ),
                ),
              ),
              AnimatedOpacity (
                opacity: _opacitySearch,
                duration: Duration(milliseconds: 200),
                child: AnimatedContainer (
                  alignment: _alignmentSearch,
                  duration: Duration(milliseconds: 200),
                  child: Button (
                    onPressed:(){ 
                      if (model.onSearch == false) {
                        setState(() {              
                          _alignmentSearch = Alignment(0.0, -.4);
                          _alignmentCatalog = Alignment.center;
                          _alignmentBag = Alignment.center;
                          _alignmentHome = Alignment.center;
                          _opacityBag = .75;
                          _opacityCatalog = .75;
                          _opacitySearch = 1.0;
                          _opacityHome = .75;
                          changePage(1, model);
                        });
                      }
                    },
                    child:
                      Icon(
                        CookMateIcon.search_icon,
                        color: StyleSheet.LIGHT_GREY,
                        size: 21,
                      ),
                  ),
                ),
              ),
              AnimatedOpacity (
                opacity: _opacityCatalog,
               duration: Duration(milliseconds: 200),
                child: AnimatedContainer (
                  alignment: _alignmentCatalog,
                  duration: Duration(milliseconds: 200),
                  child: Button (
                    onPressed:(){
                      if (model.onCatalog == false) {
                        setState(() {              
                          _alignmentCatalog = Alignment(0.0, -.4);
                          _alignmentBag = Alignment.center;
                          _alignmentHome = Alignment.center;
                          _alignmentSearch = Alignment.center;
                          _opacityBag = .75;
                          _opacityCatalog = 1.0;
                          _opacitySearch = .75;
                          _opacityHome = .75;
                          changePage(2, model);
                        });
                      }
                    },
                    child:
                      Icon(
                        CookMateIcon.catalog_icon,
                        color: StyleSheet.LIGHT_GREY,
                        size: 21,
                      ),
                  ),
                ),
              ),
              AnimatedOpacity (
                opacity: _opacityBag,
                duration: Duration(milliseconds: 200),
                child: AnimatedContainer (
                  alignment: _alignmentBag,
                  duration: Duration(milliseconds: 200),
                  child: Button (
                    onPressed:(){ 
                      if (model.onBag == false) {
                        setState(() {              
                          _alignmentBag = Alignment(0.0, -.4);
                          _alignmentHome = Alignment.center;
                          _alignmentSearch = Alignment.center;
                          _alignmentCatalog = Alignment.center;
                          _opacityBag = 1.0;
                          _opacityCatalog = .75;
                          _opacitySearch = .75;
                          _opacityHome = .75;
                          changePage(3, model);
                        });
                      }
                    },
                    child:
                      Icon(
                        CookMateIcon.bag_icon,
                        color: StyleSheet.LIGHT_GREY,
                        size: 21,
                      ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
changePage(int page, PageModel model, {bool home = false, bool search = false, bool catalog = false, bool bag = false}) {
  model.switchPage(page, home, search, catalog, bag);
}
