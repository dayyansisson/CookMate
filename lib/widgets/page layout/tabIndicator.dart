import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabIndicator extends StatefulWidget {

  static const double NAVIGATION_TEXT_SIZE = 13.5;

  final String _name;
  final int _index;

  TabIndicator({
    @required String name,
    @required int index
  }) : _name = name, _index = index;

  @override
  _TabIndicatorState createState() => _TabIndicatorState();
}

class _TabIndicatorState extends State<TabIndicator> {

  /* Constants */
  static const double _POINT_ENABLED_SIZE = TabIndicator.NAVIGATION_TEXT_SIZE * (3/8);
  static const Duration _ANIM_DURATION = const Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {

    return Consumer<TabNavigationModel>(
      builder: (context, navigationModel, _) {
        
        bool enabled = navigationModel.currentTab == widget._index;
        double indicatorSize = enabled ? _POINT_ENABLED_SIZE : 0;

        return Button(
          splashColor: StyleSheet.TRANSPARENT,
          onPressed: () {
            navigationModel.currentTab = widget._index; // Try change the tab index
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedOpacity(
                opacity: enabled ? 1 : 0.5,
                child: Text(
                  widget._name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: TabIndicator.NAVIGATION_TEXT_SIZE,
                    fontWeight: FontWeight.bold,
                    color: StyleSheet.DARK_GREY
                  ),
                ),
                duration: _ANIM_DURATION,
                curve: Curves.easeInOut,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 1)),
              AnimatedContainer(
                width: indicatorSize,
                height: indicatorSize,
                decoration: const BoxDecoration(color: StyleSheet.DARK_GREY, shape: BoxShape.circle),
                duration: _ANIM_DURATION,
                curve: Curves.easeInOut,
              ),
            ],
          ),
        );
      }
    );
  }
}