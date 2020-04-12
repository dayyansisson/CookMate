import 'package:CookMate/provider/tabNavigationModel.dart';
import 'package:CookMate/util/styleSheet.dart';
import 'package:CookMate/widgets/page%20layout/sheetTab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageSheet extends StatefulWidget {

  final List<SheetTab> tabs;
  PageSheet(this.tabs);

  @override
  _PageSheetState createState() => _PageSheetState();
}

class _PageSheetState extends State<PageSheet> with TickerProviderStateMixin {

  /* Layout Constants */
  static const double _SHEET_BORDER_RADIUS = 40;
  static const int _NAVIGATION_SPACING = 20;

  /* Animation Constants */
  static const Curve _BODY_CURVE = const Interval(0, 1, curve: Curves.easeInOutCubic);

  /* Harcoded values to replace with dynamic */
  int tabCount;
  List<String> tabNames;
  List<Widget> tabBodyContents;

  Widget bodyWidget;

  @override
  void initState() { 
    
    super.initState();

    /* Initialize tabs */
    tabCount = widget.tabs.length;
    tabNames = List<String>(tabCount);
    tabBodyContents = List<Widget>(tabCount);
    for(int i = 0; i < tabCount; i++) {
      tabNames[i] = widget.tabs[i].name;
      tabBodyContents[i] = widget.tabs[i].bodyContent;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Consumer<TabNavigationModel> (
        builder: (context, model, _) {
          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) => onHorizontalSwipe(details, model),
            onVerticalDragEnd: (DragEndDetails details) => onVerticalSwipe(details, model),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                FractionallySizedBox(     // Make sheet background white (underneath rounded edges) so that dynamically changing widgets don't show background
                  heightFactor: 0.9,
                  child: Container(color: StyleSheet.WHITE),
                ),
                Column(
                  children: <Widget> [
                    _header(model.currentTab),
                    _bodyWidgets(model.currentTab, model.previousTab)
                  ]
                ),
              ],
            )
          );
        },
      ),
    );
  }

  /* Getter for the header segment of the sheet */
  Widget _header(int tab) {
    
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(    // Rounded edges
          decoration: BoxDecoration(
            color: StyleSheet.WHITE,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_SHEET_BORDER_RADIUS),
              topRight: Radius.circular(_SHEET_BORDER_RADIUS)
            )
          ),
          height: _SHEET_BORDER_RADIUS + _NAVIGATION_SPACING,
        ),
        Positioned.fill(  // Navigation
          top: _SHEET_BORDER_RADIUS - TabIndicator.NAVIGATION_TEXT_SIZE,
          child: _navigation
        ),
      ],
    );
  }

  /* Getter for the tab navigation of the sheet */
  Widget get _navigation {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.symmetric(horizontal: 25)),
        Spacer(),
        TabIndicator(name: tabNames[0], index: 0),
        Spacer(flex: tabNames[0].length),
        TabIndicator(name: tabNames[1], index: 1),
        Spacer(flex: tabNames[1].length),
        TabIndicator(name: tabNames[2], index: 2),
        Spacer(),
        Padding(padding: EdgeInsets.symmetric(horizontal: 25)),
      ],
    );
  }

  Widget _bodyWidgets(int tab, int previousTab) {

    return Expanded(
      flex: tabBodyContents[tab] != null ? 1 : 0, // Only flex if there are any contents
      child: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: _BODY_CURVE,
            switchOutCurve: _BODY_CURVE,
            transitionBuilder: (child, animation) {
              double start = previousTab > tab ? 1 : -1;
              Animation<Offset> offsetAnimation = Tween<Offset>(begin: Offset(start, 0), end: Offset(0, 0)).animate(animation);
              if(animation.isDismissed) {
                offsetAnimation = Tween<Offset>(begin: Offset(-start, 0), end: Offset(0, 0)).animate(animation);
              }
              return SlideTransition(
                position: offsetAnimation,
                child: child
              );
            },
            child: _SheetContents(contents: tabBodyContents, index: tab),
          )
        ],
      ),
    );
  }

  void onHorizontalSwipe(DragEndDetails details, TabNavigationModel model) {

    if(details.primaryVelocity < 0) {
      model.currentTab++;
    } else if(details.primaryVelocity > 0) {
      model.currentTab--;
    }
  }

  void onVerticalSwipe(DragEndDetails details, TabNavigationModel model) {

    /* Check, don't allow user to expand sheet if tab does not allow it */
    if(!widget.tabs[model.currentTab].canExpandSheet) {
      return;
    }

    if(details.primaryVelocity > 0) {
      model.expandSheet = false;
    } else if(details.primaryVelocity < 0) {
      model.expandSheet = true;
    }
  }
}

class _SheetContents extends StatelessWidget {

  final List<Widget> contents;
  final int index;

  _SheetContents({@required this.contents, @required this.index}) : super(key: ValueKey<int>(index));

  @override
  Widget build(BuildContext context) => Container(alignment: Alignment.topLeft, child: contents[index]);
}

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