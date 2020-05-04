import 'package:CookMate/provider/pageModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';
import 'package:CookMate/util/cookMateIcons.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  @override
  Widget build(BuildContext context) {
    return Consumer<PageModel>(
      builder: (context, model, _) {
        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: StyleSheet.WHITE,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 6,
                spreadRadius: 2,
                color: StyleSheet.LIGHT_GREY.withOpacity(0.2)
              )
            ]
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavBarIcon(0, CookMateIcon.home_icon),
              _NavBarIcon(1, CookMateIcon.search_icon),
              _NavBarIcon(2, CookMateIcon.catalog_icon),
              _NavBarIcon(3, CookMateIcon.bag_icon),
            ],
          ),
        );
      }
    );
  }
}

class _NavBarIcon extends StatelessWidget {

  /* CONSTANTS */
  static const double _ENABLED_OPACITY = 1;
  static const double _DISABLED_OPACITY = 0.4;
  static const Alignment _ENABLED_ALIGNMENT = Alignment(0.0, -0.3);
  static const Alignment _DISABLED_ALIGNMENT = Alignment.center;
  static const Duration _ANIMATION_SPEED = Duration(milliseconds: 250);

  final int index;
  final IconData icon;

  _NavBarIcon(this.index, this.icon);

  @override
  Widget build(BuildContext context) {

    return Consumer<PageModel>(
      builder: (context, model, _) {
        double opacity;
        Alignment alignment;
        if(model.nextPage == index) {
          opacity = _ENABLED_OPACITY;
          alignment = _ENABLED_ALIGNMENT;
        } else {
          opacity = _DISABLED_OPACITY;
          alignment = _DISABLED_ALIGNMENT;
        }

        return AnimatedOpacity(
          opacity: opacity,
          curve: Curves.easeInOut,
          duration: _ANIMATION_SPEED,
          child: AnimatedContainer(
            alignment: alignment,
            curve: Curves.easeInOut,
            duration: _ANIMATION_SPEED,
            child: Button(
              onPressed: () => model.nextPage = index,
              child: Icon(
                icon,
                color: StyleSheet.GREY,
                size: 23,
              ),
            ),
          ),
        );
      },
    );
  }
}